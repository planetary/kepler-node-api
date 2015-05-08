{Profile} = require '../models'

{Error} = require 'mongoose'


module.exports = (app) ->
    app.post '/api/profiles', (req, res) ->
        # Creates a new profile
        Profile.create(
            'name': req.body.name
            'width': req.body.width
            'agent': req.body.agent
        )
        .then ->
            res.status(201).send(
                'code': 'OK'
                'message': 'Created'
            )
        .catch Error.ValidationError, (err) ->
            res.status(400).send(
                'code': 'VALIDATION'
                'message': err.message
                'data': err.errors
            )
        .catch (err) ->
            console.error(err)
            res.status(500).send(
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
            res.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )


    app.put '/api/profiles/:profile', (req, res) ->
        # Updates an existing profile
        req.profile.update(
            'name': req.body.name
            'width': req.body.width
            'agent': req.body.agent
        )
        .then ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Success'
            )
        .catch Error.ValidationError, (err) ->
            res.status(400).send(
                'code': 'VALIDATION'
                'message': err.message
                'data': err.errors
            )
        .catch (err) ->
            console.error(err)
            res.status(500).send(
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
            res.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )

