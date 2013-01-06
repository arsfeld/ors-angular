'use strict'

### Sevices ###

angular.module('app.models', ['ngResource', 'apiResource', 'config'])

.factory('Office', ($apiResource, User) ->
  Office = $apiResource 'offices', true

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

  Office.byNick = (nick) ->
    for office in Office.all()
      if office.nick.toLowerCase() == nick?.toLowerCase()
        return office
    return

  Office.byName = (name) ->
    for office in Office.all()
      if office.name.toLowerCase() == name?.toLowerCase()
        return office
    return

  Office
)

.factory('Product', ($apiResource, Office) ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class Product extends $apiResource('products', true)
    constructor: ->

    @property 'office',
      get: ->
        console.log "looking up for #{@officeNick}"
        Office.byNick @officeNick
      set: () ->

    @forOffice = (officeNick) ->
      Product.all().filter (product) ->
        return product.officeNick?.toLowerCase() == officeNick?.toLowerCase()
)

.factory('Registration', ($apiResource) ->
  Registration = $apiResource 'registration', true
)

.factory('User', ($apiResource) ->
  User = $apiResource 'users', true
)

.factory('Translation', ($apiResource) ->
  class Language extends $apiResource('translations', true)
    @getLanguage = (langId) ->
      for lang in @all
        if lang.langId == langId
          return lang
      lang = new Language
        langId: langId
      @all.push lang
      lang.$save()
      return lang
)

