module.exports = (app) ->
    app.post '/api/projects/:project', (req, res) ->
        # Creates a new build in a project
        res.status(501).send('Go away')


    app.put '/api/projects/:project/:build', (req, res) ->
        # Updates the metadata associated with a build
        res.status(501).send('Go away')


    app.delete '/api/projects/:project/:build', (req, res) ->
        # Deletes a build, together with all of its screenshots
        res.status(501).send('Go away')
