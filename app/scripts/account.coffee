"use strict"

###
account.controllers.main module provides the AccountMainCtrl Controller.

Main controller. Others are sub-controllers inheriting from its scope members
and methods.
Used in assets/index.html
###
angular.module("account", ["config", "flash", "user", "session"])

.controller "AccountLoginCtrl", [
  "$scope",
  "config",
  "flash",
  "$location",
  "$timeout",
  "user",
  "session",
  #"account.providers",

($scope, config, flash, $location, $timeout, user, session) ->
  
  # retrieve the current user
  $scope.session = session.current()
  $scope.user = user.current()
  
  # Globals
  $scope.providers = [] #providers.Providers
  
  # Functions
  # Open a popup to authenticate users, and redirect to account page on success
  $scope.authenticate = (provider, w, h) ->
    
    # default values for parameters
    w = w or 400
    h = h or 350
    url = provider.url
    left = (screen.width / 2) - (w / 2)
    top = (screen.height / 2) - (h / 2)
    targetWin = window.open(url, "authWindow", "toolbar=no, location=1,
      directories=no, status=no, menubar=no, scrollbars=no, resizable=no,
      copyhistory=no, width=" + w + ", height=" + h + ", top=" + top + ",
      left=" + left)
    (tick = ->
      p = targetWin.location.pathname
      
      # Authentication succeeded
      if p is config.AUTH_SUCCESS_REDIRECT_URL
        targetWin.close()
        $scope.user = user.current()
        $location.url "/account"
      
      # Authentication failed "normally"
      else if p is config.AUTH_ERROR_REDIRECT_URL
        targetWin.close()
        $scope.ErrMsgs.push "An error occured please try again."
      
      # Authentication failed, try again in one second
      else
        $timeout tick, 1000
    )()

  $scope.logout = ->
    session.destroy().success((data, status) ->
      flash.add "You have been logged out successfully", "success"
    ).error (data, status) ->
      flash.error "An error occurred please try again", "error"

    # Redirect regardless of error.
    $location.url config.AUTH_LOGOUT_REDIRECT
]
