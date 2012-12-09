statik = require 'statik'
server = statik.createServer()

console.log "Serving at " + process.env.PORT || 3333
server.listen process.env.PORT || 3333