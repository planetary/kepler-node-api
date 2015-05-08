assimilate = require '../services/assimilate'

mongoose = require 'mongoose'


Build = mongoose.Schema({
    'project':
        # The project this build belongs to
        'type': mongoose.Schema.Types.ObjectId
        'ref': 'Project'
        'required': true

    'number':
        # The build number (auto-incrementing)
        'type': Number
        'required': true

    'createdAt': Date
    'updatedAt': Date
})


Build.pre 'save', (next) ->
    this.updatedAt = new Date()
    if this.isNew
        this.createdAt = this.updatedAt
    next()


Build.index({'project': 1, 'number': 1}, {'unique': true})


module.exports = Model = assimilate mongoose.model('Build', Build)
