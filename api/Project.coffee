Build = require './Build'
Connection = require './Connection'


class Project
    constructor: (conn, projectSlug, apiKey) ->
        if typeof conn is 'object' and conn not instanceof Connection
            {conn, projectSlug, apiKey} = apiUrl

        @conn = conn
        @slug = projectSlug
        @apiKey = apiKey
        @defaults =
            'versions': [{}]
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
        @conn.rpc(method, "/projects/#{@slug}#{endpoint}", body, @apiKey)


module.exports = Project
