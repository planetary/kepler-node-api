# attempts to import and register any sub-middlewares of the current middleware
# by recursively calling them
#
# TL;DR; use this as index.coffee in all middleware subfolders
path = require "path"
fs = require "fs"


module.exports = (app) ->
    for file in fs.readdirSync(__dirname)
        stat = fs.statSync(path.join(__dirname, file))
        if stat.isDirectory()
            # subfolder; assume submodule
            require("./" + file)(app)
        else
            # subfile; only load coffee and js files to avoid stuff like
            # .gitkeep, coffeelint.json, etc.
            [file, extension] = file.split(".", 2)
            if file isnt "index" and extension in ["coffee", "js"]
                require("./" + file)(app)
