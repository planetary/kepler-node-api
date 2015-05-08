module.exports = (app) ->
    app.post '/api/profiles', (req, res) ->
        # Creates a new profile
        res.status(501).send('Go away')


    app.get '/api/profiles', (req, res) ->
        # Returns a list of profiles
        res.status(501).send('Go away')


    app.put '/api/profiles/:profile', (req, res) ->
        # Updates an existing profile
        res.status(501).send('Go away')


    app.delete '/api/profiles/:profile', (req, res) ->
        # Deletes a profile. All previously generated screenshots are still
        # available
        res.status(501).send('Go away')
