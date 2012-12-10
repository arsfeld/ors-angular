'use strict'

### Controllers ###

angular.module('app.controllers', ['app.models'])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'
  'Product'

($scope, $location, $resource, $rootScope, Product) ->

  $rootScope.loadingProducts = true
  $rootScope.allProducts = Product.query () ->
    $rootScope.loadingProducts = false

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


  $scope.save = (office) ->
    console.log new Office(office)
    new Office(office).save () ->
      console.log("done"
])

.controller('OfficesEditController', [
  '$scope'
  '$location'
  '$routeParams'
  'Office'

($scope, $location, $routeParams, Office) ->
  $scope.loading = "Loading..."

  if $routeParams.officeId?
    Office.get id: $routeParams.officeId, (office) =>
      $scope.loading = false
      $scope.office = new Office(@original = office)
  else
    $scope.loading = false

  $scope.isClean = () =>
    angular.equals(@original, $scope.office)
  $scope.destroy = () =>
    $scope.loading = "Deleting..."
    @original.remove () ->
      $location.path '#/admin/offices'
  $scope.save = () ->
    $scope.loading = "Saving..."
    new Office($scope.office).save () ->
      $location.path '/#/admin/offices'
])

.controller('ProductsController', [
 '$scope'
 'Product'

($scope, Product) ->
  loadProducts = () ->
    $scope.loading = "Loading..."
    $scope.products = Product.query () ->
      $scope.loading = false
  loadProducts()

  $scope.deleteProduct = (id) ->
    Product.remove id:id, () ->
      loadProducts()
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

  $scope.name_changed = () ->
    $scope.product.slug = $scope.product.name.toLowerCase()
      .replace('ã', 'a')
      .replace('õ', 'o')
      .replace(/-+/g, '')
      .replace(/\s+/g, '-')
      .replace(/[^a-z0-9-]/g, '')
  $scope.isClean = () =>
    angular.equals(@original, $scope.product)
  $scope.destroy = () =>
    $scope.loading = "Deleting..."
    @original.remove () ->
      $location.path '/#/admin/products'
  $scope.save = () ->
    $scope.loading = "Saving..."
    new Product($scope.product).save () ->
      $location.path '/#/admin/products'
])

.controller('WelcomeController', [
  '$scope'
  'Product'

($scope, Product) ->
  $scope.products = Product.query()

])

.controller('RegistrationController', [
  '$scope'
  '$routeParams'
  'Product'
  'Office'

($scope, $routeParams, Product, Office) ->
  if $routeParams.productId?
    Product.get id: $routeParams.productId, (product) =>
      $scope.product = new Product(@original = product)

])
