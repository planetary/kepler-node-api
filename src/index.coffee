Build = require './Build'
Connection = require './Connection'
KeplerError = require './Error'
Project = require './Project'
Screenshot = require './Screenshot'

project = null
build = null


capture = ->
    build.capture.apply(build, arguments)


configure = (properties) ->
    connection = new Connection(properties)
    properties.connection = connection
    project = new Project(properties)
    if properties.buildNumber
        build = new Build(project, properties.buildNumber)
    else
        build = project.build(properties.buildMeta)


module.exports =
    'Build': Build
    'capture': capture
    'configure': configure
    'Connection': Connection
    'Error': KeplerError  # kepler.Errror
    'KeplerError': KeplerError  # {KeplerError} = kepler
    'Project': Project
    'Screenshot': Screenshot
