'use strict'

### Directives ###

# register the module with Angular
angular.module('app.directives', [
  # require the 'app.service' module
  'app.models'
])

.filter('translate', [
  'Translation',
  '$locale'

  (Translation, $locale) ->
    (input) ->
      if input in Translation.all()?[$locale.id]
        return Translation.all()[$locale.id][input]
      else
        return "TRANSLATEME: #{input}"
])

.directive 'tooltip', () ->
  restrict:'A',
  link: (scope, element, attrs) ->
    $(element)
      .attr('title', attrs.tooltip)
      .tooltip placement: "bottom"

.directive 'colourize', () ->
  restrict: "EAC",
  link: (scope, el, attrs) ->
    scope.$watch attrs.colourize, (value) ->
      value = md5(attrs.colourize)[0..5]
      $(el).css "color", "#" + value

.directive('flickr', ['$cacheFactory',

($cacheFactory) ->
  flickrCache = $cacheFactory 'flickr'

  restrict:'EAC',
  link: (scope, element, attrs) ->
    img = $("<img src='/img/thumbnail.png' width=75 />")
    element.append img
    scope.$watch attrs.flickrImage, (value) ->
      value = attrs.flickrImage
      cached = flickrCache.get value
      if cached
        img.attr "src", cached
      else
        params =
          method: "flickr.photos.search"
          api_key: "428977a9f9188f56e0ab9dbfbc916637"
          text: value
          sort: "interestingness-desc"
          content_type: 1
          per_page: 1
          page: 1
          format: "json"
          nojsoncallback: 1
        results = $.getJSON "http://api.flickr.com/services/rest/?"+
          $.param(params), (data) ->
            photo = data.photos.photo[0]
            url = "http://farm#{photo.farm}.staticflickr.com/#{photo.server}/"+
                  "#{photo.id}_#{photo.secret}_s.jpg"
            img.attr "src", url
            flickrCache.put value, url
])

.directive 'gravatar', () ->
  restrict:'EAC',
  link: (scope, element, attrs) ->
    #console.log attrs
    scope.$watch attrs.gravatar, (value) ->
      value = attrs.gravatar
      #if value?
      #value = attrs.gravatar
      if value?
        console.log value
        hash = md5 value.toLowerCase().trim()
        tag = "<img alt=''"+
          "src='//www.gravatar.com/avatar/#{hash}?s=38&d=mm' />"
        element.append tag
