assimilate = require '../services/assimilate'
Build = require './Build'

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
        Model.findOneAsync(
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


Project.method 'regenerate', ->
    # generates a new API key
    this.key = this.key = uuid.v4().replace(/-/g, '')


Project.pre 'save', (next) ->
    this.updatedAt = new Date()
    if this.isNew
        this.createdAt = this.updatedAt
    next()


Project.pre 'remove', (next) ->
    # Delete all builds before deleting this project
    Build.findAsync(
        'project': this.id
    )
    .then (builds) ->
        builds.map (build) -> build.removeAsync()
    .then -> next()
    .catch (err) -> next(err)


module.exports = Model = assimilate mongoose.model('Project', Project)
