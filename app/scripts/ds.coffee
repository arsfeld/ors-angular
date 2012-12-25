"use strict"

###
ds.services providers cached persistence for data structures.

What does that mean?

E.g.
var u = {'name': {'givenName': 'Kyle'}};
ds.create('User', u);
// after return form sever
u.id // '1' populated from the server
###


"use strict"

angular.module("ds.stores.rest", ["config", "log"])

.factory("dsRest", [
  "config",
  "log",
  "$http",

(config, log, $http) ->
  
  # plurals contains custom plurals. E.g "people" for "person"
  plurals = {}
  
  # converts a singular name to it's plural.
  pluralize = (name) ->
    plurals[name] or name + "s"
  buildUrl = (kind, key) ->
    url = []
    url.push config.API_BASE_URL
    url.push pluralize(angular.lowercase(kind))
    url.push key if key
    url.join "/"
  
  ###
  addPlural adds a plural definition for a resource to the plurals list.
  This list is checked *first* when creating the RESTful routes.
  
  @param singular the singular name E.g. "person"
  @param plural the plural name and the name that will be used in the
  route. E.g. "people"
  ###
  addPlural = (singular, plural) ->
    plurals[angular.lowercase(singular)] = angular.lowercase(plural)

  read = (kind, key, obj) ->
    url = buildUrl(kind, key)
    promise = $http.get(url)
    promise.then (result) ->
      angular.extend obj, result.data  if obj
      result
    promise

  readMulti = (kind, keys, objs) ->
    log.assert angular.isArray(keys), "readMulti, requires an array of keys"
    log.assert angular.isArray(objs), "readMulti, requires an array of objs"
    promises = []
    angular.forEach objs, ((i) ->
      @push read(kind, keys[i], objs[i])
    ), promises
    promises

  create = (kind, obj) ->
    url = buildUrl(kind)
    promise = $http.post(url, obj)
    promise.then (result) ->
      angular.extend obj, result.data
      result
    promise

  createMulti = (kind, objs) ->
    log.assert angular.isArray(objs), "createMulti, requires an array"
    promises = []
    angular.forEach objs, ((i) ->
      @push create(kind, objs[i])
    ), promises
    promises

  update = (kind, key, obj) ->
    url = buildUrl(kind, key)
    promise = $http.put(url, obj)
    promise.then (result) ->
      angular.extend obj, result.data
      result
    promise

  updateMulti = (kind, keys, objs) ->
    log.assert angular.isArray(objs), "updateMulti, requires an array of objs"
    log.assert angular.isArray(keys), "updateMulti, requires an array of keys"
    promises = []
    angular.forEach objs, ((i) ->
      @push update(kind, keys[i], objs[i])
    ), promises
    promises

  destroy = (kind, key) ->
    url = buildUrl(kind, key)
    promise = $http.delete(url, obj)
    promise.then (result) ->
      angular.extend obj, result.data
      result
    promise

  destroyMulti = (kind, keys, objs) ->
    log.assert angular.isArray(keys), "destroyMulti, requires an array of keys"
    promises = []
    angular.forEach objs, ((i) ->
      @push destroy(kind, keys[i])
    ), promises
    promises

  create: create
  createMulti: createMulti
  read: read
  readMulti: readMulti
  
  #readAll: readAll,
  update: update
  updateMulti: updateMulti
  destroy: destroy
  destroyMulti: destroyMulti
  addPlural: addPlural
])

# TODO added other stores
angular.module("ds", ["config", "ds.stores.rest", "log"])

.factory("ds", [
  "config",
  "log",
  "$http",
  "dsRest",

(config, log, $http, dsRest) ->

  kinds = defaultStore: [dsRest]

  getStores = (kind) ->
    kinds[kind] or kinds.defaultStore
  register = (kind, stores) ->
    log.assert angular.isArray(stores), "ds: stores must be an array"
    kinds[kind] = stores
  get = (kind, key, obj) ->
    # return dsRest.read(kind, key, obj);
    for store in getStores(kind)
      promise = store.read(kind, key, obj)
    promise
  put = (kind, obj) ->
    dsRest.create kind, obj
  create = (kind, obj) ->
    dsRest.create kind, obj
  update = (kind, key, obj) ->
    dsRest.update kind, key, obj
  
  
  register: register
  get: get
  put: put
  #destroy: destroy,
  create: create
  update: update
])
