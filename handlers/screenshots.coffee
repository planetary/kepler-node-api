module.exports = (app) ->
    app.get '/api/projects/:project/screenshots', (req, res) ->
        # Returns a list of the names of all screenshots available in a project
        res.status(501).send('Go away')


    app.get '/api/projects/:project/:screenshot', (req, res) ->
        # Returns a list of sizes in which a screenshot is available
        res.status(501).send('Go away')


    app.get '/api/projects/:project/:screenshot/:version', (req, res) ->
        # Returns a list of builds in which a particular version of a
        # screenshot is available
        res.status(501).send('Go away')


    app.get '/api/projects/:project/:build/:screenshot', (req, res) ->
        # Returns a list of sizes in which a screenshot is available for a
        # particular build
        res.status(501).send('Go away')


    app.get '/api/projects/:project/:build/:screenshot/:version', (req, res) ->
        # Returns the S3 URL to display a particular version of a screenshot
        # from a particular build
        res.status(501).send('Go away')


    app.post '/api/projects/:project/:build/screenshots', (req, res) ->
        # Take screenshots of `URL` using `versions` as part of `build` of
        # `project`, storing as `name` or the sha1 of `URL` if `name` is not
        # provided. Each member of `versions` must be either the name of a
        # well-known profile or a {width, agent} pair
        res.status(501).send('Go away')
