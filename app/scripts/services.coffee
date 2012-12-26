'use strict'

### Sevices ###

angular.module('app.models', ['ngResource', 'apiResource'])

.constant('DB_NAME', "ors")
.constant('API_KEY', "50bf8346e4b0640a8ae1578c")

.factory('Office', ($apiResource) ->
  Office = $apiResource 'offices'
)

.factory('Product', ($apiResource) ->
  Product = $apiResource 'products'
)

.factory('Registration', ($apiResource) ->
  Registration = $apiResource 'registration'
)

