Screenshot = require './Screenshot'
TunnelManager = require './TunnelManager'

Promise = require 'bluebird'
dns = require 'dns'
ip = require 'ip'
url = require 'url'


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

        pieces = url.parse(targetUrl)
        if pieces.protocol not in ['http:', 'https:']
            throw new Error('Only http(s) supported')

        actualSlug = Promise.fromNode (next) ->
            # figure if targetUrl points to a non-routable ip
            dns.lookup(pieces.hostname, next)
        .spread (address, family) ->
            if ip.isPrivate(address)
                # looks like targetUrl points somewhere to a private network
                # set up a public tunnel via this machine
                if not pieces.port
                    if pieces.protocol is 'http:'
                        pieces.port = 80
                    else
                        pieces.port = 443

                TunnelManager.open(pieces.hostname, pieces.port)
                .then (tunnel) ->
                    tunnelPieces = url.parse(tunnel)
                    for key in ['protocol', 'host', 'port', 'hostname']
                        pieces[key] = tunnelPieces[key]
                    url.format(pieces)
            else
                # targetUrl is bound to a routable ip; barring net splits, the
                # kepler webservice should be able to connect to it directly
                targetUrl
        .then (target) =>
            data =
                'slug': slug
                'target': target
                'meta': meta
                'versions': versions
                'delay': delay

            @rpc('POST', '', data)
        .finally ->
            TunnelManager.close(pieces.hostname, pieces.port)

        Screenshot(@project, @, actualSlug)

    rpc: (method, endpoint, body) ->
        Promise.resolve(@number)
        .then (number) => @project.rpc(method, "/#{number}#{endpoint}", body)


module.exports = Build
