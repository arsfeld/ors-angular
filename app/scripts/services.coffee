'use strict'

### Sevices ###

angular.module('app.models', ['ngResource', 'mongolabResource'])

.constant('DB_NAME', "ors")
.constant('API_KEY', "50bf8346e4b0640a8ae1578c")

.factory('Office', ($apiResource) ->
  Office = $mongolabResource 'office'
)

.factory('Product', ($apiResource) ->
  Product = $mongolabResource 'product'
)

.factory('Registration', ($apiResource) ->
  Registration = $mongolabResource 'registration'
)