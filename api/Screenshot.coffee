Build = require './Build'

Promise = require 'bluebird'

class Screenshot
    constructor: (build, slug) ->
        if typeof project is 'object' and project not instanceof Build
            {build, slug} = build

        @build = build
        @slug = slug

    call: (method, endpoint, body) =>
        Promise.resolve(@slug)
        .then (slug) -> @build.call(method, "/{#{slug}", body)


module.exports = Screenshot
