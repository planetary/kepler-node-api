assimilate = require '../services/assimilate'

mongoose = require 'mongoose'


Profile = mongoose.Schema({
    'name':
        'type': String
        'required': true
        'unique': true

    'width': Number
    'agent': String

    'createdAt': Date
    'updatedAt': Date
})


Profile.pre 'save', (next) ->
    this.updatedAt = new Date()
    if this.isNew
        this.createdAt = this.updatedAt
    next()


module.exports = Model = assimilate mongoose.model('Profile', Profile)
