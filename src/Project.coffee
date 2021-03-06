Build = require './Build'
Connection = require './Connection'


class Project
    constructor: (connection, projectSlug, apiKey, screenshotDefaults) ->
        if \
                typeof connection is 'object' and \
                connection not instanceof Connection
            {connection, projectSlug, apiKey, screenshotDefaults} = connection

        @connection = connection
        @slug = projectSlug
        @apiKey = apiKey
        @defaults = screenshotDefaults or
            'profiles': [{}]
            'delay': 0

    get: ->
        # promises to return this project's metadata including a list of all
        # known builds and the HEAD build
        @rpc('GET', '')
        .then (project) =>
            project.head = new Build(@, project.head)
            project.builds = new Build(@, number) for number in project.builds
            delete project.screenshots  # not usable yet
            project

    set: (name, meta) ->
        # promises to update this project's name and metadata
        if typeof name is 'object' and not name instanceof String
            {name, meta} = name
        @rpc('PUT', '', {'name': name, 'meta': meta})

    remove: ->
        # promises to remove this project together with all of its builds and
        # screenshots
        @rpc('DELETE', '')

    build: (meta) ->
        # Creates a new build in the current project
        number = @rpc('POST', '', {'meta': meta})
        new Build(@, number)

    rpc: (method, endpoint, body) ->
        @connection.rpc(method, "/projects/#{@slug}#{endpoint}", body, @apiKey)


module.exports = Project
