module.exports = (app) ->
    app.post '/api/projects/:project/:build', (req, res) ->
        # Take screenshots of `URL` using `versions` as part of `build` of
        # `project`, storing as `name` or the sha1 of `URL` if `name` is not
        # provided. Each member of `versions` must be either the name of a
        # well-known profile or a {width, agent} pair
        res.status(501).send('Go away')


    app.get '/api/projects/:project/:screenshot', (req, res) ->
        # Returns a list of versions in which a screenshot is available
        versions = {}
        for screenshot in req.screenshots
            for version in screenshot.versions
                versions[version] = true

        res.status(200).send(
            'code': 'OK'
            'message': 'Success'
            'data': [version for version of versions]
        )


    app.get '/api/projects/:project/:screenshot/:version', (req, res) ->
        # Returns a list of builds in which a particular version of a
        # screenshot is available
        builds = {}
        for screenshot in req.screenshots
            for version in screenshot.versions
                if version is req.param.version
                    builds[screenshot.build] = true

        res.status(200).send(
            'code': 'OK'
            'message': 'Success'
            'data': [build for build of builds]
        )


    app.get '/api/projects/:project/:build/:screenshot', (req, res) ->
        # Returns the metadata associated with a screenshot in a particular
        # build, including the available versions
        res.status(200).send(
            'code': 'OK'
            'message': 'Success'
            'data':
                'url': req.screenshot.url
                'meta': req.screenshot.meta
                'versions': [ver.id for ver in req.screenshots.versions]
        )


    app.get '/api/projects/:project/:build/:screenshot/:version', (req, res) ->
        # Returns the metadata associated with a particular version of a
        # particular build of a screenshot, including the S3 URL needed to
        # display the resource
        for version in req.screenshot.versions
            if version.id is req.param.version
                return res.status(200).send(
                    'code': 'OK'
                    'message': 'Success'
                    'data':
                        'viewport': version.viewport
                        'agent': version.agent
                        'delay': version.delay
                        'width': version.width
                        'height': version.height
                        'size': version.size
                        'format': version.format
                        'url': req.screenshot.serve(version)
                )

        # version not found in this build
        res.status(404).send(
            'code': 'NOT_FOUND'
            'message': "Screenshot #{req.screenshot.slug} does not have a
                        #{req.param.version} version"
        )
