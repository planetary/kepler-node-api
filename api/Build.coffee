Project = require './Project'
Screnshot = require './Screenshot'

Promise = require 'bluebird'


class Build
    constructor: (project, number) ->
        if typeof project is 'object' and project not instanceof Project
            {project, number} = project

        @project = project
        @number = number

    capture: (targetUrl, slug, meta, versions, delay) =>
        # Take screenshots of `targetUrl` as part this build, storing as `slug`
        # r the sha1 of `targetUrl` if `slug` is not provided. Each member of
        # `versions` must be either the name of a well-known profile or a
        # {width, agent} pair, optionally binding it with `meta`
        #
        # Will replace any existing screenshot groups using the same slug
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

        slug = @call('POST', "", data)
        Screenshot(@project, @, slug)

    call: (method, endpoint, body) =>
        Promise.resolve(@number)
        .then (number) => @project.call(method, "/#{number}", body)
