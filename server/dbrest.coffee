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
mongoose = require "mongoose"

ObjectId = mongoose.Types.ObjectId

# Query
module.exports.query = (req, res) ->
  query = (if req.query.query then JSON.parse(req.query.query) else {})

  # Providing an id overwrites giving a query in the URL
  query = _id: new ObjectId(req.params.id) if req.params.id
  options = req.params.options or {}
  test = ["limit", "sort", "fields", "skip", "hint", "explain", "snapshot", 
          "timeout"]
  for o of req.query
    options[o] = req.query[o] if test.indexOf(o) >= 0
  
  #console.log "Querying #{req.params.collection} with #{JSON.stringify(query)}"

  collection = mongoose.connection.collection req.params.collection
  collection.find query, (err, cursor) ->
    cursor.toArray (err, data) ->
      if req.params.id
        if data.length > 0
          res.header "Content-Type", "application/json"
          res.send data[0]
        else
          res.send 404
      else
        res.header "Content-Type", "application/json"
        res.send data

# Insert
module.exports.create = (req, res) ->
  if req.body
    data = if Array.isArray(req.body) then req.body[0] else req.body
    #console.log "Body: #{JSON.stringify(data)}"
    collection = mongoose.connection.collection req.params.collection
    collection.insert data, (err, docs) ->
      res.header "Location", "/#{req.params.collection}/#{docs[0]._id}"
      res.header "Content-Type", "application/json"
      res.send '{"ok": 1}', 201
  else
    res.header "Content-Type", "application/json"
    res.send '{"ok":0}', 200

# Update
#app.put "/:db/:collection/:id", (req, res) ->
module.exports.update = (req, res) ->
  #data = if Array.isArray(req.body) then req.body[0] else req.body
  #console.log "Body: #{JSON.stringify(data)}"
  spec = _id: new ObjectId req.params.id
  collection = mongoose.connection.collection req.params.collection
  collection.update spec, req.body, (err, docs) ->
    res.header "Content-Type", "application/json"
    res.send '{"ok": 1}', 201

# Delete
#app.del "/:db/:collection/:id", (req, res) ->
module.exports.delete = (req, res) ->
  spec = _id: new ObjectId(req.params.id)
  collection = mongoose.connection.collection req.params.collection
  collection.remove spec, (err, docs) ->
    console.log err, docs
    res.header "Content-Type", "application/json"
    res.send '{"ok": 1}', 201
