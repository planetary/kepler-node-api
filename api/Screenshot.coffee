Promise = require 'bluebird'

class Screenshot
    constructor: (build, slug) ->
        Build = require './Build'
        if typeof project is 'object' and project not instanceof Build
            {build, slug} = build

        @build = build
        @slug = slug

    rpc: (method, endpoint, body) ->
        Promise.resolve(@slug)
        .then (slug) -> @build.rpc(method, "/{#{slug}", body)


module.exports = Screenshot
