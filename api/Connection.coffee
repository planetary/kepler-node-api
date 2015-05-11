KeplerError = require './Error'

Promise = require 'bluebird'
request = require 'request'


class Connection
    constructor: (apiUrl, maxSockets, socketTimeout) ->
        if typeof apiUrl is 'object' and apiUrl not instanceof String
            {apiUrl, maxSockets, socketTimeout} = apiUrl

        @url = apiUrl
        @pool =
            'maxSockets': maxSockets or 5
        @timeout = socketTimeout or 20000

    call: (method, endpoint, body, key=null) =>
        new Promise(resolve, reject) =>
            options =
                'url': "#{@url}/api#{endpoint}"
                'method': method
                'body': body
                'json': true
                'gzip': true
                'pool': @pool
                'timeout': @timeout

            if key?
                options['headers'] =
                    'X-API-Key': key

            request options, (err, res, body) ->
                if err
                    return reject(err)
                if body.code isnt 'OK'
                    err = new KeplerError(body.code, body.message, body.data)
                    return reject(err)

                resolve(body.data)


module.exports = Connection
