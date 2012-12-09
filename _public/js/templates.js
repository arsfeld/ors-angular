module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('<!DOCTYPE html>\n<html lang="en">\n  <head>\n    <meta charset="utf-8">\n    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">\n    <meta name="viewport" content="width=device-width" initial-scale="1.0">\n    <meta name="description" content="">\n    <meta name="author" content="">\n    <title ng-bind-template="{{pageTitle}}"></title>\n    <link rel="stylesheet" href="/css/app.css"><!--[if lte IE 7]>\n    <script src="http://cdnjs.cloudflare.com/ajax/libs/json2/20110223/json2.js"></script><![endif]--><!--[if lte IE 8]>\n    <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->\n    <script>\n      window.brunch = window.brunch || {};\n      window.brunch[\'auto-reload\'] = {\n        enabled: true\n      };\n    </script>\n    <script src="/js/vendor.js"></script>\n    <script src="/js/app.js"></script>\n  </head>\n  <body ng-controller="AppCtrl">\n    <div class="wrapper">\n      <div class="navbar navbar-static-top">\n        <div class="navbar-inner">\n          <div class="container">\n            <button data-toggle="collapse" data-target=".nav-collapse" class="btn btn-navbar"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button><a href="/" class="brand">AIESEC Registration System</a>\n            <div class="nav-collapse">\n              <div ng-include="\'/partials/nav.html\'"></div>\n            </div>\n          </div>\n        </div>\n      </div>\n      <div class="container main-content">\n        <div ng-view></div>\n        <!--div Angular Brunch seed app: v<span app-version></span>-->\n      </div>\n      <div class="push"></div>\n    </div>\n    <footer class="footer">\n      <div class="container">\n        <p><small>Copyright 2012 Alexandre Rosenfeld | AIESEC no Brasil\n            <!--a(href=\'https://github.com/scotch/angular-brunch-seed\') angular-brunch-seed | source--></small></p>\n      </div>\n    </footer>\n  </body>\n</html>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<ul class="nav nav-pills nav-stacked">\n  <li ng-class="getClass(\'/admin/offices\')"><a ng-href="#/admin/offices">Offices</a></li>\n  <li ng-class="getClass(\'/admin/products\')"><a ng-href="#/admin/products">Products</a></li>\n</ul>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<div>\n  <div class="row-fluid">\n    <div class="span3">\n      <div ng-include="\'/partials/admin/nav.html\'"></div>\n    </div>\n    <div class="span6">\n      <div ng-controller="OfficesController">\n        <div class="row-fluid">\n          <h2>Offices</h2>\n          <!--img(src="img/loader.gif", ng-show="loading")-->\n          <!--div(ng-hide="loading")-->\n          <div class="btn-toolbar"><a href="#/admin/offices/new" class="btn btn-primary"><i class="icon-plus"></i><span>Add Office</span></a>\n            <input type="text" ng-model="search" placeholder="Search" class="span8 search-query offices-query"/>\n          </div><span></span>\n          <table class="table table-striped table">\n            <thead></thead>\n            <tr>\n              <th>Office</th>\n              <th>Nickname</th>\n              <th></th>\n            </tr>\n            <tbody>\n              <tr ng-repeat="office in offices | filter: search | orderBy: \'name\' ">\n                <td>\n                  <div>{{office.name}}</div>\n                </td>\n                <td>{{office.nick}}</td>\n                <td><a href="#/admin/offices/edit/{{office._id.$oid}}" class="btn"> <i class="icon-edit"></i><span>Edit</span></a></td>\n              </tr>\n            </tbody>\n          </table><img src="img/loader.gif" ng-show="loading"/>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<div>\n  <div class="row-fluid">\n    <div class="span3">\n      <div ng-include="\'/partials/admin/nav.html\'"></div>\n    </div>\n    <div class="span6">\n      <div ng-controller="OfficesEditController">\n        <div class="row-fluid">\n          <h2 ng-show="office._id">Edit office</h2>\n          <h2 ng-hide="office._id">Create office</h2>\n          <h3 ng-show="loading"><img src="img/loader.gif"/></h3>\n          <div name="officeForm" ng-hide="loading" class="form">\n            <div ng-class="{error: officeForm.name.$invalid}" class="control-group">\n              <label>Name</label>\n              <input type="text" name="name" ng-model="office.name" required="required"/><span ng-show="officeForm.name.$error.required" class="help-inline">Required</span>\n            </div>\n            <div ng-class="{error: officeForm.nick.$invalid}" class="control-group">\n              <label>Nickname</label>\n              <input type="text" name="nick" ng-model="office.nick" required="required"/><span ng-show="officeForm.nick.$error.required" class="help-inline">Required</span>\n            </div><a href="#/admin/offices" class="btn">Cancel</a>\n            <button ng-click="save()" ng-disabled="isClean() || officeForm.$invalid" class="btn btn-primary">Save</button>\n            <button ng-click="destroy()" class="btn btn-danger">Delete</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<div>\n  <div class="row-fluid">\n    <div class="span3">\n      <div ng-include="\'/partials/admin/nav.html\'"></div>\n    </div>\n    <div class="span6">\n      <div ng-controller="ProductsController">\n        <div class="row-fluid">\n          <h2>Products</h2>\n          <div class="btn-toolbar"><a href="#/admin/products/new" class="btn btn-primary"><i class="icon-plus"></i><span>Add Product</span></a></div><span></span>\n          <table class="table table-striped table">\n            <thead></thead>\n            <tr>\n              <th>Name</th>\n              <th>Tagline</th>\n              <th>Slug</th>\n              <th></th>\n            </tr>\n            <tbody>\n              <tr ng-repeat="product in products | orderBy: \'name\' ">\n                <td>{{product.name}}</td>\n                <td>{{product.tagline}}</td>\n                <td>{{product.slug}}</td>\n                <td><a href="#/admin/products/edit/{{product._id.$oid}}" class="btn"> <i class="icon-edit"></i><span>Edit</span></a></td>\n              </tr>\n            </tbody>\n          </table>\n        </div><img src="img/loader.gif" ng-show="loading"/>\n      </div>\n    </div>\n  </div>\n</div>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<div>\n  <div class="row-fluid">\n    <div class="span3">\n      <div ng-include="\'/partials/admin/nav.html\'"></div>\n    </div>\n    <div class="span6">\n      <div ng-controller="ProductsEditController">\n        <div class="row-fluid">\n          <h2 ng-show="product._id">Edit product</h2>\n          <h2 ng-hide="product._id" class="ng-cloak">Create product</h2>\n          <div name="productForm" class="form">\n            <div ng-class="{error: productForm.name.$invalid}" class="control-group">\n              <label>Name</label>\n              <input type="text" name="name" ng-model="product.name" required="required"/><span ng-show="productForm.name.$error.required" class="help-inline">Required</span>\n            </div>\n            <div ng-class="{error: productForm.line.$invalid}" class="control-group">\n              <label>Tagline</label>\n              <input type="text" name="line" ng-model="product.tagline" required="required"/><span ng-show="productForm.line.$error.required" class="help-inline">Required</span>\n            </div>\n            <div ng-class="{error: productForm.tagline.$invalid}" class="control-group">\n              <label>Slug</label>\n              <input type="text" name="nick" ng-model="product.slug" required="required"/><span ng-show="productForm.slug.$error.required" class="help-inline">Required</span>\n            </div><a href="#/admin/products" class="btn">Cancel</a>\n            <button ng-click="save()" ng-disabled="isClean() || productForm.$invalid" class="btn btn-primary">Save</button>\n            <button ng-click="destroy()" class="btn btn-danger">Delete</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<ul class="nav">\n  <li ng-class="getClass(\'/welcome\')"><a ng-href="#/welcome">Home</a></li>\n  <li ng-class="getClass(\'/admin\')"><a ng-href="#/admin/offices">Admin</a></li>\n  <li ng-class="is(\'admin\')"> <a ng-href="#/admin">Admin</a>\n    <!--a.dropdown-toggle(href="#", data-toggle="dropdown") Admin-->\n    <!--  b.caret-->\n    <!--ul.dropdown-menu-->\n    <!--  li-->\n    <!--    a(ng-href="#/admin/offices") Offices-->\n    <!--  li-->\n    <!--    a(ng-href="#/admin/products") Products-->\n  </li>\n</ul>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<p>This is the partial for view 1.</p>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<p>This is the partial for view 2.</p>\n<p>\n  Showing of \'interpolate\' filter:\n  {{ \'Current version is v%VERSION%.\' | interpolate }}\n</p>');
}
return buf.join("");
};module.exports = function anonymous(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow = rethrow || jade.rethrow; merge = merge || jade.merge;
var buf = [];
with (locals || {}) {
var interp;
var __indent = [];
buf.push('\n<div ng-controller="RegistrationController">\n  <h3>Select below which program you are interested:</h3>\n  <div class="row-fluid">\n    <ul class="nav nav-pills">\n      <li ng-repeat="product in products | orderBy: \'name\' " class="span3"><a href="#/register/{{product.slug}}">\n          <h2>{{product.name}}</h2>\n          <h4>{{product.tagline}}</h4></a></li>\n    </ul>\n  </div>\n</div>');
}
return buf.join("");
};