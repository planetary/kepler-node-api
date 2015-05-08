{Schema, model} = require 'mongoose'
Promise = require 'bluebird'


Project = Schema(
    'name'
        'type': String
        'required': true

    'slug':
        'type': String
        'required': true
        'unique': true

    'key':
        # API key for this project
        'type': String
        'required': true

    'head':
        # The most recent build number
        'type': Number
        'default': 0

    'createdAt':
        'type': Date
        'default': -> new Date()

    'updatedAt':
        'type': Date
        'default': -> new Date()
)


Project.pre 'save', (next) ->
    if not this.isNew
        this.updatedAt = new Date()
        this.regenerate()

    base = this.slug = this.name.toLowerCase().replace(/[^a-z0-9]+/g, '-')

    trySlug = (model) =>
        Model.findOne(
            'slug': this.slug
        )
        .then (project) =>
            if project and project.id isnt this.id
                # already exists; generate a new suffix
                rand = Math.floor(65536 * Math.random())
                this.slug = base + '-' + rand.toString(16)
                trySlug()
    trySlug()
    .then -> next()
    .catch (err) -> next(err)


Project.pre 'remove', (next) ->
    Build.find(
        'project': req.project.id
    )
    .then (builds) ->
        builds.map (build) -> build.remove()
    .then -> next()
    .catch (err) -> next(err)


Project.method 'regenerate', ->
    # generates a new API key
    this.key = this.key = uuid.v4().replace('-', '')


module.exports = Model = model('Project', Project)
Promise.promisifyAll(Model)
Promise.promisifyAll(Model.prototype)
