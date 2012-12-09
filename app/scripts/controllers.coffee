'use strict'

### Controllers ###

angular.module('app.controllers', ['app.models'])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'

($scope, $location, $resource, $rootScope) ->

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  # getClass compares the current url with the id.
  # If the current url starts with the id it returns 'active'
  # otherwise it will return '' an empty string. E.g.
  #
  #   # current url = '/products/1'
  #   getClass('/products') # returns 'active'
  #   getClass('/orders') # returns ''
  #
  $scope.getClass = (id) ->
    if $scope.activeNavId.substring(0, id.length) == id then 'active' else ''
])

.controller('OfficesController', [
 '$scope'
 'Office'

($scope, Office) ->
  $scope.loading = true

  $scope.offices = Office.query () ->
    $scope.loading = false
])

.controller('OfficesEditController', [
  '$scope'
  '$location'
  '$routeParams'
  'Office'

($scope, $location, $routeParams, Office) ->
  $scope.loading = true

  if $routeParams.officeId?
    Office.get id: $routeParams.officeId, (office) =>
      $scope.loading = false
      $scope.office = new Office(@original = office)
  else
    $scope.loading = false

  $scope.isClean = () =>
    angular.equals(@original, $scope.office)
  $scope.destroy = () =>
    $scope.loading = true
    @original.remove () ->
      $location.path '#/admin/offices'
  $scope.save = () ->
    $scope.loading = true
    new Office($scope.office).save () ->
      $location.path '/#/admin/offices'
])

.controller('ProductsController', [
 '$scope'
 'Product'

($scope, Product) ->
  $scope.loading = "Loading..."
  $scope.products = Product.query () ->
    $scope.loading = false
])

.controller('ProductsEditController', [
  '$scope'
  '$location'
  '$routeParams'
  'Product'

($scope, $location, $routeParams, Product) ->
  $scope.loading = if $routeParams.productId? then 'Loading...' else false
  console.log $scope.loading
  if $routeParams.productId?
    Product.get id: $routeParams.productId, (product) =>
      $scope.loading = false
      $scope.product = new Product(@original = product)

  $scope.isClean = () =>
    angular.equals(@original, $scope.product)
  $scope.destroy = () =>
    $scope.loading = true
    @original.remove () ->
      $location.path '/#/admin/products'
  $scope.save = () ->
    $scope.loading = "Saving..."
    new Product($scope.product).save () ->
      $location.path '/#/admin/products'
])

.controller('RegistrationController', [
  '$scope'
  'Product'

($scope, Product) ->
  $scope.products = Product.query()

])

