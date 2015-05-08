{Project} = require '../models'

{ValidationError} = require 'mongoose'


module.exports = (app) ->
    app.post '/api/projects', (req, res) ->
        # Creates a new project
        data = req.params.all()
        Project.create(
            'name': data.name
            'meta': data.meta
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


    app.get '/api/projects/:project', (req, res) ->
        # Returns a project's metadata together with all of its builds
        Build.find(
            'project': req.project.id
        )
        .then (builds) ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Success'
                'data':
                    'name': req.project.name
                    'meta': req.project.meta
                    'builds': builds
            )
        .catch (err) ->
            console.error(err)
            req.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )


    app.put '/projects/:project', (req, res) ->
        # Updates an existing project's metadata
        data = req.params.all()
        req.project.update(
            'name': data.name
            'meta': data.meta
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


    app.delete '/projects/:project', (req, res) ->
        # Deletes a project, together with all of its builds and screenshots
        req.project.remove()
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
