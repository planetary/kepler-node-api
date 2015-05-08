mongoose = require 'mongoose'
Promise = require 'bluebird'


Profile = mongoose.Schema(
    'name'
        'type': String
        'required': true
        'unique': true

    'width': Number
    'agent': String

    'createdAt':
        'type': Date
        'default': -> new Date()

    'updatedAt':
        'type': Date
        'default': -> new Date()
)


Profile.pre 'save', (next) ->
    if not this.isNew
        this.updatedAt = new Date()
    next()


Model = mongoose.model('Profile', Profile)
Promise.promisifyAll(Model)
Promise.promisifyAll(Model.prototype)
module.exports = Model
