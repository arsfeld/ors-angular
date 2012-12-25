"use strict"

###
user.services provides services for interacting with user.
This service serves as a convenient wrapper for other user related services.
###
angular.module("user", ["config", "log", "ds", "flash"])

.factory "user", [
  "config",
  "log",
  "ds",
  "$location",
  "$rootScope",
  "$route",

(config, log, ds, $location, $rootScope, $route) ->
  
  ###
  defaultUser
  
  @type {Object}
  ###
  defaultUser =
    id: ""
    name:
      honorificPrefix: ""
      givenName: ""
      middleName: ""
      familyName: ""
      honorificSuffix: ""
      formatted: ""

    email: ""
    emails: []
    birthday: ""
    gender: ""
    image: ""
    roles: []
    kind: ""
    provider: ""
    url: ""
    urls: []
    utcOffset: ""

    displayName: ->
      if @name and (@name.givenName or @name.familyName)
        a = []
        a = (if @name.givenName then a.concat(@name.givenName) else a)
        a = (if @name.familyName then a.concat(@name.familyName) else a)
        return a.join(" ")  if a.length
      "Anonymous User"

    isAuthenticated: ->
      @id isnt ""

    isAdmin: ->
      for role in @roles
        return true if role is "admin"
      return false
  
  # attributes
  # TODO change display name into a function so we can use it here.
  
  # methods
  
  ###
  User object
  
  @param value existing vales you would like to merge.
  @return a new User object
  ###
  
  # TODO can the value param be removed?
  User = (value) ->
    angular.copy value or defaultUser, this
  
  ###
  Retrieves a user from the remote server.
  
  @url `{API_URL}/user/{userId}`
  @method GET
  
  @param userId the id of the user you would like to retrieve.
  
  @return $http promise
  ###
  get = (userId, user) ->
    ds.get "user", userId, user
  
  ###
  Creates a user on the remote server.
  
  @url `{API_URL}/user`
  @method POST
  @payload {object} User
  
  @param user {object} a User object that will be created.
  Properties:
  - email (required)
  - password
  - new (required)
  All other properties are optional
  - name
  - givenName
  - familyName
  - middleName
  
  @return $http promise
  If an error occurs the promises error function will receive a list of
  errors E.g.
  [
  {
  code: 10,
  message: 'Invalid email'
  }
  ]
  ###
  create = (user) ->
    ds.create "User", user
  
  ###
  Update updates an existing User with a remote server.
  
  @url `{API_URL}/user/{user.id}`
  @method POST
  @payload {object} User
  
  @param user {object} the User object that will be updated.
  
  @return $http promise
  If an error occurs the promises error function will receive a list of
  errors E.g.
  [
  {
  code: 10,
  message: 'Invalid email'
  }
  ]
  ###
  update = (user) ->
    log.assert user.id, "user: id is required to preform an update"
    ds.update "User", user.id, user
  
  ###
  Retrieves the requesting user's user object from a remote server.
  
  @url `{API_URL}/user/me`
  @method GET
  
  @return User object - immediately returns a User object.
  The object is empty, but will be populated once the server returns.
  ###
  current = ->
    ds.get "User", "me", currentUser
    currentUser

  currentUser = new User()
  User: User
  get: get
  create: create
  update: update
  current: current
]
