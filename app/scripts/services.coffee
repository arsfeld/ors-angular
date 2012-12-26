'use strict'

### Sevices ###

angular.module('app.models', ['ngResource', 'apiResource'])

.factory('Office', ($apiResource) ->
  Office = $apiResource 'offices'
)

.factory('Product', ($apiResource) ->
  Product = $apiResource 'products'
)

.factory('Registration', ($apiResource) ->
  Registration = $apiResource 'registration'
)

.factory('User', ($apiResource) ->
  User = $apiResource 'users'
)
