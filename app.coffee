#!/usr/bin/env coffee
config = require './config'

express = require 'express'
mongoose = require 'mongoose'
parser = require 'body-parser'

# connect to database
mongoose.connect(config.mongo.uri, config.mongo.options)
mongoose.connection.once 'open', ->
    # init express & body parser
    app = express()
    app.use(parser.json())


    # load & init middlewares
    require('./middlewares')(app)

    # load & init handlers
    require('./handlers')(app)

    # start server
    app.listen config.server.port, ->
        console.log("Server started on #{config.server.port}. To stop, hit
                     Ctrl + C")
