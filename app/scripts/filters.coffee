'use strict'

### Filters ###

angular.module('app.filters', [
  'app.models'
])

.filter('translate', [
  'Translation',
  '$locale'

  (Translation, $locale) ->
    (input) ->
      language = Translation.getLanguage $locale.id
      console.log language
      if input in Translation.all()?[$locale.id]?
        return Translation.all()[$locale.id][input]
      else
        #return "**'#{input}'**"
        return input
])