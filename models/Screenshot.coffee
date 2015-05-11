assimilate = require '../services/assimilate'
config = require '../config'

base32 = require 'base32'
cryoto = require 'crypto'
mongoose = require 'mongoose'
url = require 'url'


ScreenshotVersion = mongoose.Schema({
    'id':
        # Either the name of the profile, or the sha1 hash of
        # width + agent
        'type': String
        'required': true
        'validate':
            'validator': (val) -> val.match(/^[a-z0-9\-\.]+$/)
            'msg': 'Versions must be lowercase and URL friendly'

    # The size of the viewport width in pixels that this screenshot was
    # rendered on (may be undefined / null if the default was used)
    # Note that this is a hint; the actual output width may be larger if the
    # site does not scale correctly and creates a horizontal scrollbar (in
    # general, you want to fix such things as horizontal scrollbars cause a
    # bad user experience)
    'width': Number

    # The user agent used to generate this screenshot (may be undefined /
    # null if the default was used)
    'agent': String

    'delay':
        # The amount of time given to the site to finish rendering before
        # snapping the screenshot, in milliseconds.
        'type': Number
        'min': 0
        'max': 5000

    'format':
        # The format this screenshot was saved in
        'type': String
        'required': true
        'enum': ['png', 'gif', 'jpeg']
        'default': 'png'
})


Screenshot = mongoose.Schema({
    'project':
        # The project this group of screenshots belongs to
        'type': mongoose.Schema.Types.ObjectId
        'ref': 'Project'
        'required': true

    'build':
        # The build this group of screenshots were taken in
        'type': Number
        'required': true

    'slug':
        # The name of this group of screenshots; if not set by the user, the
        # sha1 of the target will be used
        'type': String
        'required': true
        'validate': [
            'validator': (val) -> val.match(/^[a-z0-9\-\.]+$/)
            'msg': 'Slugs must be lowercase and URL friendly'

            'validator': (val) -> val.match(/[^0-9]$/)
            'msg': 'Slugs must contain at least one non-numeric character'
        ]

    'target':
        # The URL of the page that is rendered in this group of screenshots
        'type': String
        'required': true
        'validate':
            'validator': (val) ->
                # this is a bit of a joke and not relied upon, but may prevent
                # some rather common mistakes
                pieces = url.parse(val)
                if pieces.protocol not in ['http', 'https']
                    return false

                if pieces.hostname in ['localhost', '127.0.0.1', '[127.0.0.1]'
                                       '[::1]']
                    return false

                true
            'msg': 'Only valid non-loopback HTTP(S) urls are supported'

    # api specified metadata, if any
    'meta': mongoose.Schema.Types.Mixed

    # All the versions available for this screenshot
    'versions': [ScreenshotVersion]

    'createdAt': Date
    'updatedAt': Date
})


Screenshot.method 'serve', (version) ->
    if typeof version is 'object'
        version = version.id
    project = if typeof @project is 'object' then @project.id else @project
    "https://#{config.aws.bucket}.s3.amazonaws.com/#{project}-#{@build}-
    #{@slug}-#{version}"


Screenshot.pre 'validate', (next) ->
    if @isNew
        if not @slug
            # Auto generate slug if not present
            hash = crypto.createHash('sha1')
            hash.update(@target)
            @slug = hash.digest('base64').replace('+', '-').replace('/', '.')
                .toLowerCase()
                .substring(0, 8)

            if @slug.match(/^[0-9]+$/)
                # one in a million chance; avoid collision with build numbers
                @slug = @slug.substring(0, 4) + '-' + @slug.substring(4)

        for version in @versions
            # Auto-generate version id if not present
            if not version.id
                hash = crypto.createHash('sha1')
                hash.update((@width or '') + (@agent or ''))
                @id = hash.digest('base64').replace('+', '-').replace('/', '.')
                    .toLowerCase()
                    .substring(0, 8)



Screenshot.pre 'save', (next) ->
    @updatedAt = new Date()
    if @isNew
        @createdAt = @updatedAt
    next()


Screenshot.index({'project': 1, 'slug': 1, 'build': 1}, {'unique': true})


module.exports = Model = assimilate mongoose.model('Screenshot', Screenshot)
