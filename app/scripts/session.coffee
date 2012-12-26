"use strict"

###
session.services provides services for interacting with sessions.
###
angular.module("session", ["config", "log", "flash", "apiResource"])


.factory("session", [
  "config"
  "flash"
  "log"
  "$apiResource"
  "$location"
  "$rootScope"
  "$route"

(config, flash, log, $apiResource, $location, $rootScope, $route) ->
  
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
  
  SessionResource = $apiResource 'sessions'

  class Session extends SessionResource
    constructor: ->
      super()
      @id = ""
      @userId = ""
      @userName = ""
      @roles = []
      @nextUrl = ""
      @isAuthenticated = ""
      @isAdmin = ""
    @current = @$get()

  nextUrl = ""

  currentSession = Session.current()
  
  ###
  Code modified from
  https://groups.google.com/forum/?fromgroups=#!starred/angular/POXLTi_JUgg
  By Adam Wynne
  ###
  $rootScope.$on "$routeChangeSuccess", (current) ->
    #console.log currentSession
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
      if auth?
        
        # if authentication *IS* required but user is *NOT* authenticated
        if auth and not currentSession.isAuthenticated
          flash.add "You must be logged in to view that. Please log.", "warn"
          
          # save current location to session for post authentication redirect
          nextUrl = loginUrl
        
        #$location.url(loginUrl);
        
        # if authentication is *NOT* required but user *IS* authenticated
        flash.add "You are already logged in", "info" if \
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
        flash.add "You are already logged in", "info" if \
          not admin and currentSession.isAdmin

  
  # TODO redirect to previous
  #$location.url('/');
  Session: Session
  read: read
  create: create
  update: update
  current: current
  destroy: destroy
])
