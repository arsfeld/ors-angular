'use strict'

### Sevices ###

angular.module('app.models', ['ngResource', 'mongolabResource'])

.constant('DB_NAME', "ors")
.constant('API_KEY', "50bf8346e4b0640a8ae1578c")

.factory('Office', ($mongolabResource) ->
  Office = $mongolabResource 'office'
)

.factory('Product', ($mongolabResource) ->
  Product = $mongolabResource 'product'
)

.factory('Registration', ($mongolabResource) ->
  Registration = $mongolabResource 'registration'
)