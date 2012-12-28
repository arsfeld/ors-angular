angular.module('apiResource', ['config', 'ngResource'])
  .factory '$apiResource', [
    '$resource'
    'config'

    ($resource, config) ->
      (collectionName) ->
        Collection = $resource "#{config.API_BASE_URL}/db/" +
                               "#{collectionName}/:id",
          id:'@_id',
            update:
              method:'PUT'

        Collection.getById = (id, cb, errorcb) ->
          Collection.get id:id, cb, errorcb

        Collection.load = (cb) ->
          #@items = @items || {}
          #angular.copy(@items, @query(cb))
          @items = @query =>
            @$emit 'load', @items
            if cb
              cb(@items)

        Collection.all = () ->
          return this.items

        Collection.$on = (event, callback) ->
          @callbacks = @callbacks || {}
          @callbacks[event] = @callbacks[event] || []
          @callbacks[event].push callback

        Collection.$emit = (event, data) ->
          @callbacks = @callbacks || {}

          callbacks = @callbacks[event]
          if callbacks
            for callback in callbacks
              callback.apply @, data || []

          return @

        #Collection.query = (id, cb, errorcb) ->


        ###
        Collection::update = (cb, errorcb) ->
          Collection.update id:this._id,
            angular.extend {}, this, _id:undefined,
            cb, errorcb
        ###

        Collection::save = (savecb, updatecb, errorSavecb, errorUpdatecb) ->
          if @_id?
            @$update savecb, errorUpdatecb
          else
            @$save savecb, errorSavecb

        Collection::remove = (cb, errorcb) ->
          Collection.remove id: @_id, cb, errorcb

        Collection
  ]