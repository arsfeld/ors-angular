'use strict'

### Translations ###

angular.module('app.translations', ['translate', 'translate.directives'])

.run(['translate'], () ->
  translate.add(
  	"Select below which program you are interested:":
  	  "Selecione os programas que você está interessado"
  )
)
