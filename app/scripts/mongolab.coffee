angular.module('mongolabResource', ['ngResource'])
  .factory '$mongolabResource', [
    '$resource'
    'API_KEY'
    'DB_NAME',

    ($resource, API_KEY, DB_NAME) ->
      (collectionName) ->
        Collection = $resource "https://api.mongolab.com/api/1/databases/" +
                                "#{DB_NAME}/collections/#{collectionName}/:id",
          apiKey:API_KEY
          id:'@_id.$oid',
            update:
              method:'PUT'

        Collection.getById = (id, cb, errorcb) ->
          Collection.get id:id, cb, errorcb

        Collection::update = (cb, errorcb) ->
          Collection.update id:this._id.$oid,
            angular.extend {}, this, _id:undefined,
            cb, errorcb

        Collection::save = (savecb, updatecb, errorSavecb, errorUpdatecb) ->
          if @_id?.$oid?
            @update savecb, errorUpdatecb
          else
            @$save savecb, errorSavecb

        Collection::remove = (cb, errorcb) ->
          Collection.remove id: @_id.$oid, cb, errorcb

        Collection
  ]