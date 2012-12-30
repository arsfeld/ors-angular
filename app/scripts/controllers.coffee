'use strict'

### Controllers ###

angular.module('app.controllers', [
  'app.models'
  'account'
  'ui'
])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'
  '$locale'
  '$http'
  'Product'
  'Office'

($scope, $location, $resource, $rootScope, $locale, $http, Product, Office) ->

  $locale.id = "pt-br"

  $scope.products = Product.all()
  $scope.offices = Office.all()

  $rootScope.$copy = angular.copy

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  $rootScope.locale = $locale.id

  ###
  get = $http.$get
  $http.$get = ($httpBackend, $browser, $cacheFactory, $rootScope, $q,
    $injector) ->
    console.log $q
    get($httpBackend, $browser, $cacheFactory, $rootScope, $q, $injector)
  ###

  ###
  $scope.$on '$routeChangeStart', (evt, next, current) ->
    url = next.templateUrl
    if url?
      [path..., ext] = url.split "."
      next.templateUrl = "#{path}.#{$locale.id}.#{ext}"
  ###

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
    #console.log "Refresh requested"
    #$scope.offices = Office.all()
    #update = Office.query () ->
    #  $scope.offices = update
    Office.load()

  $scope.offices = Office.all()

  Office.$on 'load', () ->
    $scope.offices = Office.all()
  #Office.bind "load", (data) ->
  #  $scope.offices = Office.all()
  
  $scope.office = {}

  #$scope.$watch 'offices', () ->
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

.controller('UsersController', [
 '$scope'
 'User'
 'Office'

($scope, User, Office) ->

  refresh = () ->
    User.load()

  User.$on 'load', () ->
    $scope.users = User.all()
  Office.$on 'load', () ->
    $scope.offices = Office.all()

  $scope.users = User.all()
  $scope.offices = Office.all()

  #$scope.$watch 'offices', () ->
    #return unless @offices
    #_.each @offices, (office) ->
    #  console.log office

  $scope.user = {}

  $scope.edit = () ->
    @original = angular.copy(@user)
    @editing = true
  $scope.cancel = () ->
    angular.copy(this.original, @user)
    #@editing = false
  $scope.delete = () ->
    @user.remove () =>
      @deleteDialog = false
      refresh()
  $scope.save = () ->
    new User(@user).save () =>
      @user = {}
      refresh()
])

.controller('ProductsController', [
 '$scope'
 'Product'
 'Office'

($scope, Product, Office) ->

  refresh = () ->
    Product.load()

  $scope.products = Product.all()
  $scope.offices = Office.all()

  $scope.product = {}

  Product.$on 'load', () ->
    $scope.products = Product.all()

  $scope.name_changed = () ->
    $scope.product.slug = $scope.product.name.toLowerCase()
      .replace('ã', 'a')
      .replace('õ', 'o')
      .replace('é', 'e')
      .replace('ê', 'e')
      #.replace(/-+/g, '')
      .replace(/\s+/g, '-')
      .replace(/[^a-z0-9-]/g, '')
  $scope.delete = () ->
    @product.remove () =>
      @deleteDialog = false
      refresh()
  $scope.save = () ->
    new Product(@product).save () =>
      @product = {}
      refresh()
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

.controller('FormBuilderCtrl', [
  '$scope'

($scope) ->
  $scope = this
  $scope.newField = {}
  $scope.fields = [
    type: "text"
    name: "Name"
    placeholder: "John Doe"
    order: 10
  ]
  $scope.editing = false
  $scope.tokenize = (slug1, slug2) ->
    result = slug1
    result = result.replace(/[^-a-zA-Z0-9,&\s]+/g, "")
    result = result.replace(/-/g, "_")
    result = result.replace(/\s/g, "-")
    result += "-" + $scope.token(slug2)  if slug2
    result

  $scope.saveField = ->
    console.log $scope.newField
    $scope.newField.value = {} if $scope.newField.type is "checkboxes"
    if not $scope.editing
      $scope.fields[$scope.editing] = $scope.newField
      $scope.editing = false
    else
      $scope.fields.push $scope.newField
    $scope.newField = order: 0

  $scope.editField = (field) ->
    $scope.editing = $scope.fields.indexOf(field)
    $scope.newField = field

  $scope.splice = (field, fields) ->
    fields.splice fields.indexOf(field), 1

  $scope.addOption = ->
    $scope.newField.options = []  if $scope.newField.options is 'undefined'
    $scope.newField.options.push order: 0

  $scope.typeSwitch = (type) ->
    return type if type not in ["checkboxes", "select", "radio"]
    return "multiple"
])

.controller('WelcomeController', [
  '$scope'
  'Product'

($scope, Product) ->
  $scope.office = 0
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
