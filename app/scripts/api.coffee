angular.module('apiResource', ['config', 'ngResource'])
  .factory '$apiResource', [
    '$resource'
    'config'

    ($resource, config) ->
      (collectionName) ->
        Collection = $resource config.API_BASE_URL = "/db/#{collectionName}/:id",
          id:'@_id',
            update:
              method:'PUT'

        Collection.getById = (id, cb, errorcb) ->
          Collection.get id:id, cb, errorcb

        Collection::update = (cb, errorcb) ->
          Collection.update id:this._id,
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