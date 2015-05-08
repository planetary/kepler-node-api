Promise = require 'bluebird'
mongoose = require 'mongoose'


assimilate = (target, name) ->
    if Object.getOwnPropertyDescriptor(target, name)
        return

    func = target[name]
    if typeof(func) is 'function'
        target[name] = ->
            result = func.apply(this, arguments)
            if result instanceof mongoose.Promise
                result = Promise.resolve(result)
            return result


module.exports = (target) ->
    # Assimilates all promises returned by all functions on `target` and
    # `target.prototype` to bluebird
    for property of target
        assimilate(target, property)

    for property of target::
        assimilate(target::, property)

    target
