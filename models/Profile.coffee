assimilate = require '../services/assimilate'

mongoose = require 'mongoose'


Profile = mongoose.Schema({
    'name':
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
})


Profile.pre 'save', (next) ->
    if not this.isNew
        this.updatedAt = new Date()
    next()


module.exports = Model = assimilate mongoose.model('Profile', Profile)
