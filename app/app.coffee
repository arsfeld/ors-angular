'use strict'

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'ngResource'
  'app.controllers'
  'app.models'
  'app.directives'
  'app.filters'
  'app.translations'
])

App.config([
  '$routeProvider'
  '$locationProvider'
  
  ($routeProvider, $locationProvider, config) ->

    $routeProvider

      .when '/welcome',
        templateUrl: '/partials/welcome.html'
      .when '/register/:productId',
        templateUrl: '/partials/registration.html'
      .when '/admin/offices',
        templateUrl: '/partials/admin/offices.html'
      .when '/admin/offices/edit/:officeId',
        templateUrl: '/partials/admin/offices_edit.html'
      .when '/admin/offices/new',
        templateUrl: '/partials/admin/offices_edit.html'
      .when '/admin/products',
        templateUrl: '/partials/admin/products.html'
      .when '/admin/products/edit/:productId',
        templateUrl: '/partials/admin/products_edit.html'
      .when '/admin/products/new',
        templateUrl: '/partials/admin/products_edit.html'

      # Catch all
      .otherwise redirectTo: '/welcome'

    # Without server side support html5 must be disabled.
    $locationProvider.html5Mode(false)
])