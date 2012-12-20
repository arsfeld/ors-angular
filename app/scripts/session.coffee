"use strict"

###
session.services provides services for interacting with sessions.
###
angular.module("session", ["config", "log", "ds", "flash"])


.factory "session", [
  "config",
  "flash",
  "log",
  "ds",
  "$location",
  "$rootScope",
  "$route",


(config, flash, log, ds, $location, $rootScope, $route) ->
  
  ###
  defaultSession
  
  @type {Object}
  ###
  
  # attributes
  
  ###
  Session object
  
  @param value existing vales you would like to merge.
  @return a new Session object
  ###
  
  # TODO can the value param be removed?
  Session = (value) ->
    angular.copy value or defaultSession, this
  read = (sessionId, session) ->
    ds.get "Session", sessionId, session
  create = (session) ->
    ds.create "Session", session
  update = (session) ->
    log.assert session.id, "user: id is required to preform an update"
    ds.update "Session", session.id, session
  destroy = (sessionId) ->
    ds.destroy "Session", sessionId
  current = ->
    ds.get "Session", "me", currentSession
    currentSession
  nextUrl = ""
  defaultSession =
    id: ""
    userId: ""
    userName: ""
    roles: []
    nextUrl: ""
    isAuthenticated: ""
    isAdmin: ""

  currentSession = new Session()
  
  ###
  Code modified from 
  https://groups.google.com/forum/?fromgroups=#!starred/angular/POXLTi_JUgg
  By Adam Wynne
  ###
  $rootScope.$on "$routeChangeSuccess", (current) ->
    currentUrl = $location.url()
    loginUrl = config.AUTH_LOGIN_REDIRECT_URL
    if currentUrl isnt loginUrl and nextUrl isnt loginUrl
      $location.url nextUrl
      nextUrl = ""
    if $route.current and $route.current.$route
      auth = $route.current.$route.auth
      admin = $route.current.$route.admin
      
      # if auth is set
      # E.g. `auth: true` or `auth: false`
      if auth isnt `undefined`
        
        # if authentication *IS* required but user is *NOT* authenticated
        if auth and not currentSession.isAuthenticated
          flash.add "You must be logged in to view that. Please log.", "warn"
          
          # save current location to session for post authentication redirect
          nextUrl = loginUrl
        
        #$location.url(loginUrl);
        
        # if authentication is *NOT* required but user *IS* authenticated
        flash.add "You are already logged in", "info"  if 
          not auth and currentSession.isAuthenticated
      
      # TODO redirect to previous
      #$location.url('/');
      
      # if admin is set:
      # E.g. `admin: true` or `admin: false`
      if admin?
        
        # if admin *IS* required but user is *NOT* admin
        if admin and not currentSession.isAdmin
          flash.add "You must be an admin to view that. Please log.", "warn"
          
          # save current location to session for post authentication redirect
          nextUrl = currentUrl
        
        #$location.url(loginUrl);
        
        # if admin is *NOT* required but user *IS* an admin
        flash.add "You are already logged in", "info"  if 
          not admin and currentSession.isAdmin

  
  # TODO redirect to previous
  #$location.url('/');
  Session: Session
  read: read
  create: create
  update: update
  current: current
  destroy: destroy
]
