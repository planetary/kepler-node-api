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

    build: (meta) =>
        # Creates a new build in the current project
        number = @call('POST', "", {'meta': meta})
        Build(@, number)

    call: (method, endpoint, body) =>
        @connection.call(method, "/projects/#{@slug}", body, @apiKey)


module.exports = Project
