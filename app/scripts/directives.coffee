'use strict'

### Directives ###

# register the module with Angular
angular.module('app.directives', [
  # require the 'app.service' module
  'app.models'
])

.directive 'tooltip', () ->
  restrict:'A',
  link: (scope, element, attrs) ->
    $(element)
      .attr 'title', scope.$eval attrs.tooltip
      .tooltip placement: "right"

