'use strict'

### Controllers ###

angular.module('app.controllers', ['app.models', 'ui'])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'
  '$locale'
  'Product'
  'Office'

($scope, $location, $resource, $rootScope, $locale, Product, Office) ->

  products = Product.query () ->
    $rootScope.allProducts = products
  offices = Office.query () ->
    $rootScope.allOffices = offices

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  $scope.$on '$routeChangeStart', (next, current) ->
    console.log current
    url = current.templateUrl
    if url?
      parts = url.split "."
      [path..., ext] = parts
      #parts.push(parts.pop())
      current.templateUrl = path + ext

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

  refresh = () ->
    update = Office.query () ->
      $scope.offices = update
  refresh()

  $scope.$watch 'offices', () ->
    #return unless @offices
    #_.each @offices, (office) ->
    #  console.log office

  $scope.edit = () ->
    @original = angular.copy(@office)
    @editing = true
  $scope.cancelEdit = () ->
    angular.copy(this.original, @office)
    @editing = false
  $scope.delete = () ->
    @deleting = true
    @office.remove () =>
      @deleting = false
      @deleteDialog = false
      refresh()
  $scope.save = () ->
    this.editing = false
    this.saving = true
    new Office(@office).save () =>
      this.saving = false
      @office = {}
      refresh()
])

.controller('ProductsController', [
 '$scope'
 'Product'

($scope, Product) ->
  loadProducts = () ->
    $scope.loading = "Loading..."
    products = Product.query () ->
      $scope.loading = false
      $scope.products = products
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

])

.controller('RegistrationController', [
  '$scope'
  '$rootScope'
  '$routeParams'
  'Product'
  'Office'
  'Registration'

($scope, $rootScope, $routeParams, Product, Office, Registration) ->
  $rootScope.$watch 'allProducts', () ->
    if not $rootScope.allProducts?
      return
    product = (product for product in $rootScope.allProducts when \
      product.slug == $routeParams.productId)
    $scope.product = product[0]
    $scope.registration = {product: $scope.product.slug, subscribe: true}

  $scope.register = () ->
    new Registration($scope.registration).save()
])

.controller('RegistrationsController', [
  '$scope'
  'Registration'

($scope, Registration) ->
  $scope.registrations = Registration.query()
])
