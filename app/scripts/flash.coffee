"use strict"

# Service to broadcast messages to all scopes, since the $broadcast call is made from the $rootScope
angular.module("flash.services", ["config.services"])

.factory "flash", [
  "$rootScope", 

($rootScope) ->
  flashes = []
  
  ###
  add adds a single flash message.
  
  @param message
  A string representing the flash message
  @param level
  the classification of the flash options are:
  - 'info' // the default
  - 'success'
  - 'error'
  ###
  add: (message, level) ->
    
    # default value for the level parameter
    level = level or "info"
    flash =
      message: message
      level: level

    flashes.push flash
    
    # tell child scope that this flash has been added
    $rootScope.$broadcast "flash.add", flash

  
  ###
  all returns all flashes, but does **not** clear them
  @return {Array}
  ###
  all: ->
    flashes

  
  ###
  clear removes all flashes
  ###
  clear: ->
    $rootScope.$broadcast "flash.clear", true
    flashes = []

  
  ###
  getAll returns all flashes and clears them
  
  @return {Array}
  ###
  getAll: ->
    $rootScope.$broadcast "flash.remove"
    f = angular.copy(flashes)
    flashes = []
    f
]
