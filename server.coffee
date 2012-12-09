statik = require 'statik'
server = statik.createServer('_public')

port = process.env.PORT || 3333
console.log "Serving at #{port}"
server.listen port