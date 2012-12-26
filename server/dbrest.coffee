'use strict';
# 
#    rest.js
#    mongodb-rest
#
#    Base on code written by Tom de Grunt on 2010-10-03.
#    Portions by Tom de Grunt Copyright (c) 2010 Tom de Grunt.
#    Portions by Alexandre Rosenfeld Copyright (c) 2012 Alexandre Rosenfeld
#
#    	This file is part of mongodb-rest.
#
#mongo = require("mongodb")
#app = module.parent.exports.app
#config = module.parent.exports.config
#config = require "./config"
#util = require("./util")
#BSON = mongo.BSONPure

#MongoClient = mongo.MongoClient
#Server = mongo.Server

mongoose = require "mongoose"

###
Query
###
#app.get "/:db/:collection/:id?", (req, res) ->
module.exports.query = (req, res) ->
  query = (if req.query.query then JSON.parse(req.query.query) else {})

  # Providing an id overwrites giving a query in the URL
  query = _id: new BSON.ObjectID(req.params.id)  if req.params.id
  options = req.params.options or {}
  test = ["limit", "sort", "fields", "skip", "hint", "explain", "snapshot", "timeout"]
  for o of req.query
    options[o] = req.query[o] if test.indexOf(o) >= 0
  
  console.log "Querying #{req.params.collection} with #{query}"

  collection = mongoose.connection.collection req.params.collection
  collection.find query, (err, cursor) ->
    cursor.toArray (err, data) ->
      console.log data
      if req.params.id
        if data.length > 0
          res.header "Content-Type", "application/json"
          res.send data[0]
        else
          res.send 404
      else
        res.header "Content-Type", "application/json"
        res.send data


  ###
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
                result = docs[0] #util.flavorize(docs[0], "out")
                res.header "Content-Type", "application/json"
                res.send result
              else
                res.send 404
            else
              docs.forEach (doc) ->
                result.push doc #util.flavorize(doc, "out")

              res.header "Content-Type", "application/json"
              res.send result
            db.close()
  ###

###
Insert
###
#app.post "/:db/:collection", (req, res) ->
module.exports.create = (req, res) ->
  if req.body
    data = if Array.isArray(req.body) then req.body[0] else req.body
    console.log "Body: #{JSON.stringify(data)}"
    collection = mongoose.connection.collection req.params.collection
    collection.insert data, (err, docs) ->
      res.header "Location", "/#{req.params.collection}/{docs[0]._id}"
      res.header "Content-Type", "application/json"
      res.send JSON.stringify ok: 1, 201
    ###
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
    ###
  else
    res.header "Content-Type", "application/json"
    res.send "{\"ok\":0}", 200

###
Update
###
#app.put "/:db/:collection/:id", (req, res) ->
module.exports.update = (req, res) ->
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
#app.del "/:db/:collection/:id", (req, res) ->
module.exports.delete = (req, res) ->
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
