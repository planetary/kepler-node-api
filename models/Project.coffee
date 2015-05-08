assimilate = require '../services/assimilate'

mongoose = require 'mongoose'
uuid = require 'uuid'


Project = mongoose.Schema({
    'name':
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

    'createdAt': Date
    'updatedAt': Date
})


Project.pre 'validate', (next) ->
    if this.isNew
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


Project.pre 'save', (next) ->
    this.updatedAt = new Date()
    if this.isNew
        this.createdAt = this.updatedAt
    next()


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


module.exports = Model = assimilate mongoose.model('Project', Project)
