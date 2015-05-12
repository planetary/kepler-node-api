Screenshot = require './Screenshot'

Promise = require 'bluebird'


class Build
    constructor: (project, number) ->
        # circular import
        Project = require './Project'
        if typeof project is 'object' and project not instanceof Project
            {project, number} = project

        @project = project
        @number = number

    get: ->
        # promises to return this builds's metadata including a list of all
        # known screenshots
        @rpc('GET', '')
        .then (build) =>
            build.screenshots = new Screenshot(@, slug) \
                                for slug in build.screenshots
            build

    set: (meta) ->
        # promises to update this builds's metadata
        @rpc('PUT', '', {'meta': meta})

    remove: ->
        # promises to remove this build together with all of its screenshots
        @rpc('DELETE', '')

    capture: (targetUrl, slug, meta, versions, delay) ->
        # Take screenshots of `targetUrl` as part this build, storing as `slug`
        # or the sha1 of `targetUrl` if `slug` is not provided. Each member of
        # `versions` must be either the name of a well-known profile or a
        # {width, agent} pair, optionally binding it with `meta`
        if typeof targetUrl is 'object' and targetUrl not instanceof String
            {targetUrl, slug, meta, versions, delay} = targetUrl

        if typeof versions is 'undefined'
            versions = @project.defaults.versions
        if typeof delay is 'undefined'
            delay = @project.defaults.delay

        data =
            'slug': slug
            'target': targetUrl
            'meta': meta
            'versions': versions
            'delay': delay

        slug = @rpc('POST', '', data)
        Screenshot(@project, @, slug)

    rpc: (method, endpoint, body) ->
        Promise.resolve(@number)
        .then (number) => @project.rpc(method, "/#{number}#{endpoint}", body)


module.exports = Build
