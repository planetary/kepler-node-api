{Schema, model} = require 'mongoose'
Promise = require 'bluebird'


ScreenshotVersion = Schema(
    'id':
        # Either the name of the profile, or the sha1 hash of
        # viewport + agent
        'type': String
        'required': true

    # The size of the viewport width in pixels that this screenshot was
    # rendered on (may be undefined / null if the default was used)
    # Note that this is a hint; the actual output width may be larger if the
    # site does not scale correctly and creates a horizontal scrollbar (in
    # general, you want to fix such things as horizontal scrollbars cause a
    # bad user experience)
    'viewport': Number

    # The user agent used to generate this screenshot (may be undefined /
    # null if the default was used)
    'agent': String

    'delay':
        # The amount of time given to the site to finish rendering before
        # snapping the screenshot, in milliseconds.
        'type': Number
        'min': 0
        'max': 5000

    'width':
        # The actual width of this screenshot, in pixels
        'type': Number
        'required': true
        'min': 0

    'height':
        # The actual height of this screenshot, in pixels
        'type': Number
        'required': true
        'min': 0

    'size':
        # The size of this screenshot, in bytes
        'type': Number
        'required': true
        'min': 0

    'format':
        # The format this screenshot is saved in
        'type': String
        'required': true
        'enum': ['png', 'gif', 'jpeg']
        'default': 'png'

    'quality':
        # The compression quality of this screenshot. Actual meaning depends on
        # the format: for PNG and GIF it specifies the zlib compression level,
        # whereas for JPEG it specifies the image quantization factor
        'type': String
        'required': true
        'min': 0,
        'max': 100
        'default': 60
)


Screenshot = Schema(
    'project':
        # The project this build belongs to
        'type': Schema.Types.ObjectId
        'ref': 'Project'
        'required': true

    'build':
        # The build this group of screenshots were taken in
        'type': Number
        'required': true

    'slug':
        # The name of this group of screenshots; if not set by the user, the
        # sha1 of the URL will be used
        'type': String
        'required': true

    'url':
        # The URL of the page that is rendered in this group of screenshots
        'type': String
        'required': true

    'versions': [Screenshot]

    'createdAt':
        'type': Date
        'default': -> new Date()

    'updatedAt':
        'type': Date
        'default': -> new Date()
)


Screenshot.pre 'save', (next) ->
    if not this.isNew
        this.updatedAt = new Date()
    next()


Screenshot.index({'project': 1, 'slug': 1, 'build': 1}, {'unique': true})


module.exports = Model = model('Screenshot', Screenshot)
Promise.promisifyAll(Model)
Promise.promisifyAll(Model.prototype)
