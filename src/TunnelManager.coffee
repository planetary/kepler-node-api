Promise = require 'bluebird'
localtunnel = require 'localtunnel'
url = require 'url'


# amount of time (in milliseconds) to keep tunnels alive waiting for calls to
# `open` after the last call to `close`.
LINGER_DURATION = 1000


class TunnelManager
    @tunnels = {}  # bind hashes to tunnels
    @translations = {}  # binds remote hashes to local hashes

    @open: (hostname, port) ->
        # Promises to return a http(s) URL that will be tunneled to
        # (hostname, port) via the local machine; The tunnel will remain active
        # until a time that `close` is called with the same arguments.
        # If called multiple times with the same argument pair, the same amount
        # of calls to `close` are required to actually close the tunnel.
        hash = "#{hostname}:#{port}"
        if @translations[hash]
            hash = @translations[hash]

        if @tunnels[hash]
            # Tunnel already exists; bump ref count and return cached copy
            @_acquire(hash)
            Promise.resolve(@tunnels[hash].url)
        else
            # No active tunnel found; spawn a new one
            Promise.fromNode (next) ->
                localtunnel(port, 'local_host': hostname, next)
            .then (tunnel) =>
                # cache the tunnel for a while
                pieces = url.parse(tunnel.url)
                remoteHash = "#{pieces.hostname}:#{pieces.port}"
                @translations[remoteHash] = hash
                @tunnels[hash] = tunnel

                # delete all cached data when the tunnel is closed
                tunnel.on 'close', =>
                    delete @translations[remoteHash]
                    delete @tunnels[hash]

                # bump ref count and return
                @_acquire(hash)
                tunnel.url

    @close: (hostname, port) ->
        # Closes an existing tunnel to (hostname, port); if the tunnel was
        # opened multiple times, it will not be actually closed until `close`
        # is called the same amount of times.
        # Fails silently if there is no such tunnel.
        hash = "#{hostname}:#{port}"
        if @translations[hash]
            hash = @translations[hash]

        if @tunnels[hash]
            # if the tunnel exists; drop a reference to it
            @_release(hash)

    @references = {}  # binds hashes to the number of tunnel references
    @timers = {}  # binds hashes to the timers that will close tunnels

    @_acquire: (hash) ->
        # Adds a reference to the tunnel identified by `hash`
        # INTERNAL USE ONLY, DO NOT CALL THIS DIRECTLY!
        @references[hash] = (@references[hash] or 0) + 1
        if @timers[hash]
            # this tunnel has at least one reference; don't close it
            clearTimeout(@timers[hash])
            delete @timers[hash]

    @_release: (hash) ->
        # Releases a reference to the tunnel identified by `hash`
        # INTERNAL USE ONLY, DO NOT CALL THIS DIRECTLY!
        if not @references[hash]
            return  # tunnel does not exist

        @references[hash] -= 1
        if @references[hash] is 0
            # the last reference to this tunnel was deleted; close it after
            # waiting LINGER_DURATION milliseconds
            delete @references[hash]
            @timers[hash] = setTimeout =>
                @tunnels[hash].close()
                delete @tunnels[hash]
                delete @timers[hash]
                # @translations will be deleted by the 'close' handler
            , LINGER_DURATION


module.exports = TunnelManager
