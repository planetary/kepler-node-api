mongoose = require 'mongoose'


Profile = mongoose.Schema(
    'name'
        'type': String
        'required': true

    'width': Number
    'agent': String

    'createdAt':
        'type': Date
        'default': -> new Date()

    'updatedAt':
        'type': Date
        'default': -> new Date()
)


module.exports = mongoose.model('Profile', Profile)
