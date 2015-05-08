mongoose = require 'mongoose'


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


module.exports = mongoose.model('Project', Project)
