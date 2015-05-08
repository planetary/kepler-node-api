mongoose = require 'mongoose'
Promise = require 'bluebird'


Build = mongoose.Schema(
    'project':
        # The project this build belongs to
        'type': mongoose.Schema.Types.ObjectId
        'ref': 'Project'
        'required': true

    'number'
        # The build number (auto-incrementing)
        'type': Number
        'required': true

    'createdAt':
        'type': Date
        'default': -> new Date()

    'updatedAt':
        'type': Date
        'default': -> new Date()
)


Build.pre 'save', (next) ->
    if not this.isNew
        this.updatedAt = new Date()
    next()


Build.index({'project': 1, 'number': 1}, {'unique': true})


Model = mongoose.model('Build', Build)
Promise.promisifyAll(Model)
Promise.promisifyAll(Model.prototype)
module.exports = Model
