'use strict'

### Sevices ###

angular.module('app.models', ['ngResource', 'apiResource', 'config'])

.factory('Office', ($apiResource, User) ->
  Office = $apiResource 'offices'

  #Office = Model "offices", () ->
  #  @persistence Model.REST, "#{config.API_BASE_URL}/db/offices/:id"
  Office::adminUsers = () ->
    users = User.all()
    unless @admin?
      return []
    $.map @admin, (i) ->
      for user in users
        if user.email == i
          return user

  Office.load (data) ->
    console.log data

  Office
)

.factory('Product', ($apiResource) ->
  Product = $apiResource 'products'
)

.factory('Registration', ($apiResource) ->
  Registration = $apiResource 'registration'
)

.factory('User', ($apiResource) ->
  User = $apiResource 'users'

  User.load()

  User
)
