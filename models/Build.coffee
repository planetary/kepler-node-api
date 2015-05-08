mongoose = require 'mongoose'


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


Build.index({'project': 1, 'number': 1}, {'unique': true})


module.exports = mongoose.model('Build', Build)
