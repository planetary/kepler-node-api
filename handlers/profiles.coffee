{Profile} = require '../models'

{ValidationError} = require 'mongoose'


module.exports = (app) ->
    app.post '/api/profiles', (req, res) ->
        # Creates a new profile
        data = req.params.all()
        Profile.create(
            'name': data.name
            'width': data.width
            'agent': data.agent
        )
        .then ->
            res.status(201).send(
                'code': 'OK'
                'message': 'Created'
            )
        .catch ValidationError, (err) ->
            req.status(400).send(
                'code': 'VALIDATION'
                'message': 'Invalid field(s)'
                'data': err
            )
        .catch (err) ->
            console.error(err)
            req.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )


    app.get '/api/profiles', (req, res) ->
        # Returns a list of profiles
        Profile.find()
        .then (profiles) ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Success'
                'data': profiles.map (profile) -> profile.name
            )
        .catch (err) ->
            console.error(err)
            req.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )


    app.put '/api/profiles/:profile', (req, res) ->
        # Updates an existing profile
        data = req.params.all()
        req.profile.update(
            'name': data.name
            'width': data.width
            'agent': data.agent
        )
        .then ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Success'
            )
        .catch ValidationError, (err) ->
            req.status(400).send(
                'code': 'VALIDATION'
                'message': 'Invalid field(s)'
                'data': err
            )
        .catch (err) ->
            console.error(err)
            req.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )


    app.delete '/api/profiles/:profile', (req, res) ->
        # Deletes a profile. All previously generated screenshots are still
        # available
        req.profile.remove()
        .then ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Success'
            )
        .catch (err) ->
            console.error(err)
            req.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )

