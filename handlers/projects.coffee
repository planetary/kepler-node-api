module.exports = (app) ->
    app.post '/api/projects', (req, res) ->
        # Creates a new project


    app.get '/api/projects/:project', (req, res) ->
        # Returns a project's metadata together with all of its builds


    app.put '/projects/:project', (req, res) ->
        # Updates an existing project's metadata


    app.delete '/projects/:project', (req, res) ->
        # Deletes a project, together with all of its builds and screenshots
