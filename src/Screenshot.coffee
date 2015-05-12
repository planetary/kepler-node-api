Promise = require 'bluebird'

class Screenshot
    constructor: (build, slug) ->
        Build = require './Build'
        if typeof project is 'object' and project not instanceof Build
            {build, slug} = build

        @build = build
        @slug = slug

    get: ->
        # promises to return this screenshot's metadata including a list of all
        # known versions
        @rpc('GET', '')

    set: (meta) ->
        # promises to update this screenshot's metadata
        @rpc('PUT', '', {'meta': meta})

    remove: ->
        # promises to remove this screenshot with all of its versions
        @rpc('DELETE', '')

    rpc: (method, endpoint, body) ->
        Promise.resolve(@slug)
        .then (slug) -> @build.rpc(method, "/{#{slug}#{endpoint}", body)


module.exports = Screenshot
