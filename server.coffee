statik = require 'statik'
server = statik.createServer()

server.listen process.env.PORT || 3333