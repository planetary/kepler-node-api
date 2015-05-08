#!/usr/bin/env coffee
config = require './config'

express = require 'express'

# init express
app = express()

# load & init middlewares
require('./middlewares')(app)

# load & init handlers
require('./handlers')(app)

# start server
app.listen(config.server.port)
