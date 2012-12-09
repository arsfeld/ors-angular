'use strict';

var App;

App = angular.module('app', ['ngCookies', 'ngResource', 'app.controllers', 'app.models', 'app.directives', 'app.filters']);

App.config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider, config) {
    $routeProvider.when('/welcome', {
      templateUrl: '/partials/welcome.html'
    }).when('/admin/offices', {
      templateUrl: '/partials/admin/offices.html'
    }).when('/admin/offices/edit/:officeId', {
      templateUrl: '/partials/admin/offices_edit.html'
    }).when('/admin/offices/new', {
      templateUrl: '/partials/admin/offices_edit.html'
    }).when('/admin/products', {
      templateUrl: '/partials/admin/products.html'
    }).when('/admin/products/edit/:productId', {
      templateUrl: '/partials/admin/products_edit.html'
    }).when('/admin/products/new', {
      templateUrl: '/partials/admin/products_edit.html'
    }).otherwise({
      redirectTo: '/welcome'
    });
    return $locationProvider.html5Mode(false);
  }
]);

angular.element(document).ready(function() {
  return angular.bootstrap(document, ['app']);
});
'use strict';

/* Controllers
*/

angular.module('app.controllers', ['app.models']).controller('AppCtrl', [
  '$scope', '$location', '$resource', '$rootScope', function($scope, $location, $resource, $rootScope) {
    $scope.$location = $location;
    $scope.$watch('$location.path()', function(path) {
      return $scope.activeNavId = path || '/';
    });
    return $scope.getClass = function(id) {
      if ($scope.activeNavId.substring(0, id.length) === id) {
        return 'active';
      } else {
        return '';
      }
    };
  }
]).controller('OfficesController', [
  '$scope', 'Office', function($scope, Office) {
    $scope.loading = true;
    return $scope.offices = Office.query(function() {
      return $scope.loading = false;
    });
  }
]).controller('OfficesEditController', [
  '$scope', '$location', '$routeParams', 'Office', function($scope, $location, $routeParams, Office) {
    var _this = this;
    $scope.loading = true;
    if ($routeParams.officeId != null) {
      Office.get({
        id: $routeParams.officeId
      }, function(office) {
        $scope.loading = false;
        _this.original = office;
        return $scope.office = new Office(_this.original);
      });
    } else {
      $scope.loading = false;
    }
    $scope.isClean = function() {
      return angular.equals(_this.original, $scope.office);
    };
    $scope.destroy = function() {
      return self.original.destroy(function() {
        return $location.path('#/admin/offices');
      });
    };
    return $scope.save = function() {
      var _ref;
      if (((_ref = $scope.office) != null ? _ref._id : void 0) != null) {
        return $scope.office.update(function() {
          return $location.path('#/admin/offices');
        });
      } else {
        return Office.save($scope.office, function() {
          return $location.path('#/admin/offices');
        });
      }
    };
  }
]).controller('ProductsController', [
  '$scope', 'Product', function($scope, Product) {
    $scope.loading = true;
    return $scope.products = Product.query(function() {
      return $scope.loading = false;
    });
  }
]).controller('ProductsEditController', [
  '$scope', '$location', '$routeParams', 'Product', function($scope, $location, $routeParams, Product) {
    var _this = this;
    if ($routeParams.productId != null) {
      Product.get({
        id: $routeParams.productId
      }, function(product) {
        return $scope.product = new Product(_this.original = product);
      });
    }
    $scope.isClean = function() {
      return angular.equals(self.original, $scope.product);
    };
    $scope.destroy = function() {
      return self.original.destroy(function() {
        return $location.path('/#/admin/products');
      });
    };
    return $scope.save = function() {
      var _ref;
      return (_ref = $scope.product) != null ? _ref.save(function() {
        return $location.path('/#/admin/products');
      }) : void 0;
    };
  }
]).controller('RegistrationController', [
  '$scope', 'Product', function($scope, Product) {
    return $scope.products = Product.query();
  }
]);
'use strict';

/* Directives
*/

angular.module('app.directives', ['app.models']).directive('appVersion', [
  'version', function(version) {
    return function(scope, elm, attrs) {
      return elm.text(version);
    };
  }
]);
'use strict';

/* Filters
*/

angular.module('app.filters', []).filter('interpolate', [
  'version', function(version) {
    return function(text) {
      return String(text).replace(/\%VERSION\%/mg, version);
    };
  }
]);

angular.module('mongolabResource', ['ngResource']).factory('$mongolabResource', [
  '$resource', 'API_KEY', 'DB_NAME', function($resource, API_KEY, DB_NAME) {
    return function(collectionName) {
      var Collection;
      Collection = $resource("https://api.mongolab.com/api/1/databases/" + ("" + DB_NAME + "/collections/" + collectionName + "/:id"), {
        apiKey: API_KEY,
        id: '@_id.$oid'
      }, {
        update: {
          method: 'PUT'
        }
      });
      Collection.getById = function(id, cb, errorcb) {
        return Collection.get({
          id: id
        }, cb, errorcb);
      };
      Collection.prototype.update = function(cb, errorcb) {
        return Collection.update({
          id: this._id.$oid
        }, angular.extend({}, this, {
          _id: void 0
        }), cb, errorcb);
      };
      Collection.prototype.save = function(savecb, updatecb, errorSavecb, errorUpdatecb) {
        var _ref;
        if (((_ref = this._id) != null ? _ref.$oid : void 0) != null) {
          return this.update(updatecb, errorUpdatecb);
        } else {
          return this.$save(savecb, errorSavecb);
        }
      };
      Collection.prototype.remove = function(cb, errorcb) {
        return Collection.remove({
          id: this._id.$oid
        }, cb, errorcb);
      };
      return Collection;
    };
  }
]);
'use strict';

/* Sevices
*/

angular.module('app.models', ['ngResource', 'mongolabResource']).constant('DB_NAME', "ors").constant('API_KEY', "50bf8346e4b0640a8ae1578c").factory('Office', function($mongolabResource) {
  var Office;
  return Office = $mongolabResource('office');
}).factory('Product', function($mongolabResource) {
  var Product;
  return Product = $mongolabResource('product');
});
