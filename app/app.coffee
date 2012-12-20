'use strict'

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'ngResource'
  'app.controllers'
  'app.models'
  'app.directives'
  'app.filters'
])

.factory('$templateCache', [
  '$cacheFactory'
  '$http'
  '$injector'
  '$locale'

  ($cacheFactory, $http, $injector, $locale) ->
    cache = $cacheFactory 'templates'
    get: (url) ->
      original_url = url
      console.log url
      [path, mid..., ext] = url.split "."
      url = "#{path}.#{$locale.id}.#{ext}"
      console.log url
      cached = cache.get original_url
      if cached?
        return cached
      return $http.get url, cache: cache

    put: (key, value) ->
      cache.put key, value

])

.config([
  '$routeProvider'
  '$locationProvider'
  '$httpProvider'
  
  ($routeProvider, $locationProvider, $httpProvider, config) ->

    $routeProvider

      .when '/welcome',
        templateUrl: '/partials/welcome.html'
      .when '/register/:productId',
        templateUrl: '/partials/registration.html'

      # Authentication
      .when('/auth', {redirectTo : '/auth/login'})
      .when '/auth/login',
        templateUrl : '/partials/auth/login.html'
      .when('/signup', {templateUrl : '/partials/account/signup.html'})
      .when('/login', {templateUrl : '/partials/account/login.html'})

      # Admin Section
      .when '/admin'
        redirectTo: '/admin/offices'
      .when '/admin/registrations',
        templateUrl: '/partials/admin/registrations.html'
      .when '/admin/offices',
        templateUrl: '/partials/admin/offices.html'
      .when '/admin/products',
        templateUrl: '/partials/admin/products.html'
      .when '/admin/products/edit/:productId',
        templateUrl: '/partials/admin/products_edit.html'
      .when '/admin/products/new',
        templateUrl: '/partials/admin/products_edit.html'

      # Catch all
      .otherwise redirectTo: '/welcome'

    # Without server side support html5 must be disabled.
    $locationProvider.html5Mode true
])