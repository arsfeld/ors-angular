# 
#    rest.js
#    mongodb-rest
#
#    Created by Tom de Grunt on 2010-10-03.
#    Copyright (c) 2010 Tom de Grunt.
#    	This file is part of mongodb-rest.
#
mongo = require("mongodb")
app = module.parent.exports.app
config = module.parent.exports.config
util = require("./util")
BSON = mongo.BSONPure

###
Query
###
app.get "/:db/:collection/:id?", (req, res) ->
  query = (if req.query.query then JSON.parse(req.query.query) else {})
  
  # Providing an id overwrites giving a query in the URL
  query = _id: new BSON.ObjectID(req.params.id)  if req.params.id
  options = req.params.options or {}
  test = ["limit", "sort", "fields", "skip", "hint", "explain", "snapshot", "timeout"]
  for o of req.query
    options[o] = req.query[o]  if test.indexOf(o) >= 0
  db = new mongo.Db(req.params.db, new mongo.Server(config.db.host, config.db.port,
    auto_reconnect: true
  ))
  db.open (err, db) ->
    db.authenticate config.db.username, config.db.password, ->
      db.collection req.params.collection, (err, collection) ->
        collection.find query, options, (err, cursor) ->
          cursor.toArray (err, docs) ->
            result = []
            if req.params.id
              if docs.length > 0
                result = util.flavorize(docs[0], "out")
                res.header "Content-Type", "application/json"
                res.send result
              else
                res.send 404
            else
              docs.forEach (doc) ->
                result.push util.flavorize(doc, "out")

              res.header "Content-Type", "application/json"
              res.send result
            db.close()







###
Insert
###
app.post "/:db/:collection", (req, res) ->
  if req.body
    db = new mongo.Db(req.params.db, new mongo.Server(config.db.host, config.db.port,
      auto_reconnect: true
    ))
    db.open (err, db) ->
      db.authenticate config.db.username, config.db.password, ->
        db.collection req.params.collection, (err, collection) ->
          
          # We only support inserting one document at a time
          collection.insert (if Array.isArray(req.body) then req.body[0] else req.body), (err, docs) ->
            res.header "Location", "/" + req.params.db + "/" + req.params.collection + "/" + docs[0]._id.toHexString()
            res.header "Content-Type", "application/json"
            res.send "{\"ok\":1}", 201
            db.close()




  else
    res.header "Content-Type", "application/json"
    res.send "{\"ok\":0}", 200


###
Update
###
app.put "/:db/:collection/:id", (req, res) ->
  spec = _id: new BSON.ObjectID(req.params.id)
  db = new mongo.Db(req.params.db, new mongo.Server(config.db.host, config.db.port,
    auto_reconnect: true
  ))
  db.open (err, db) ->
    db.authenticate config.db.username, config.db.password, ->
      db.collection req.params.collection, (err, collection) ->
        collection.update spec, req.body, true, (err, docs) ->
          res.header "Content-Type", "application/json"
          res.send "{\"ok\":1}"
          db.close()






###
Delete
###
app.del "/:db/:collection/:id", (req, res) ->
  spec = _id: new BSON.ObjectID(req.params.id)
  db = new mongo.Db(req.params.db, new mongo.Server(config.db.host, config.db.port,
    auto_reconnect: true
  ))
  db.open (err, db) ->
    db.authenticate config.db.username, config.db.password, ->
      db.collection req.params.collection, (err, collection) ->
        collection.remove spec, (err, docs) ->
          res.header "Content-Type", "application/json"
          res.send "{\"ok\":1}"
          db.close()




