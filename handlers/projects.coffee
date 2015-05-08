{Build, Project} = require '../models'

{Error} = require 'mongoose'


module.exports = (app) ->
    app.post '/api/projects', (req, res) ->
        # Creates a new project, returning its slug
        Project.createAsync(
            'name': req.body.name
        )
        .then (project) ->
            res.status(201).send(
                'code': 'OK'
                'message': 'Created'
                'data': project.slug
            )
        .catch Error.ValidationError, (err) ->
            res.status(400).send(
                'code': 'VALIDATION'
                'message': err.message
                'data': err.errors
            )
        .catch (err) ->
            res.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )


    app.get '/api/projects/:project', (req, res) ->
        # Returns a project's metadata together with all of its builds
        Build.findAsync(
            'project': req.project.id
        )
        .then (builds) ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Success'
                'data':
                    'name': req.project.name
                    'builds': builds
                    'createAt': req.project.createdAt
                    'updatedAt': req.project.updatedAt
            )
        .catch (err) ->
            console.error(err)
            res.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )


    app.put '/api/projects/:project', (req, res) ->
        # Updates an existing project's metadata, returning its slug (usually
        # the same but it might be modified)
        req.project.updateAsync(
            'name': req.body.name
        )
        .then ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Success'
                'data': req.project.slug
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


    app.delete '/api/projects/:project', (req, res) ->
        # Deletes a project, together with all of its builds and screenshots
        req.project.removeAsync()
        .then ->
            res.status(200).send(
                'code': 'OK'
                'message': 'Deleted'
            )
        .catch (err) ->
            console.error(err)
            res.status(500).send(
                'code': 'INTERNAL'
                'message': 'The server had an internal error'
            )
