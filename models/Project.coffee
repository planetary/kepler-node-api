mongoose = require 'mongoose'
Promise = require 'bluebird'


Project = mongoose.Schema(
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
    next()


Model = mongoose.model('Project', Project)
Promise.promisifyAll(Model)
Promise.promisifyAll(Model.prototype)
module.exports = Model
