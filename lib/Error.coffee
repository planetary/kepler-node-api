class KeplerError extends Error
    constructor: (code, message, data) ->
        super(message)
        @code = code
        @data = data


module.exports = KeplerError
