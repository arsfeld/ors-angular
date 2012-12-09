statik = require 'statik'
server = statik.createServer('_public')

console.log "Serving at " + process.env.PORT || 3333
server.listen process.env.PORT || 3333