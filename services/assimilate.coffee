bluebird = require 'bluebird'


module.exports = (model) ->
    bluebird.promisifyAll(model)
    bluebird.promisifyAll(model::)
    model
