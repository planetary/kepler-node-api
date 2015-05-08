assimilate = require '../services/assimilate'
Screenshot = require './Screenshot'

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


Build.pre 'remove', (next) ->
    # Delete all screenshots before deleting this build
    Screenshot.findAsync(
        'project': this.project
        'build': this.number
    )
    .then (screenshots) ->
        screenshots.map (screenshot) -> screenshot.removeAsync()
    .then -> next()
    .catch (err) -> next(err)


Build.index({'project': 1, 'number': 1}, {'unique': true})


module.exports = Model = assimilate mongoose.model('Build', Build)
