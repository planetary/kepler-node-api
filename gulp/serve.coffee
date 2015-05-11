{_extend} = require 'util'
path = require 'path'

module.exports = (gulp, plugins) ->
    options =
        'script': 'app.coffee'
        'ext': 'coffee'
        'watch': [
            path.resolve(__dirname, '../config/*')
            path.resolve(__dirname, '../handlers/*')
            path.resolve(__dirname, '../middlewares/*')
            path.resolve(__dirname, '../models/*')
            path.resolve(__dirname, '../services/*')
        ]

    gulp.task 'serve:dev', 'serves the app in development mode', ->
        plugins.nodemon(_extend(
            options,
            'env':
                'NODE_ENV': 'development'
        ))

    gulp.task 'serve:test', 'serves the app in testing mode', ->
        plugins.nodemon(_extend(
            options,
            'env':
                'NODE_ENV': 'testing'
        ))

    gulp.task 'serve:stage', 'serves the app in staging mode', ->
        plugins.nodemon(_extend(
            options,
            'env':
                'NODE_ENV': 'staging'
        ))

    gulp.task 'serve:prod', 'serves the app in production mode', ->
        plugins.nodemon(_extend(
            options,
            'env':
                'NODE_ENV': 'production'
        ))
