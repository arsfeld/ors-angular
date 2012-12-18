exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  files:
    javascripts:
      joinTo:
        'js/app.js': /^client/
        'js/vendor.js': /^vendor/
        'test/scenarios.js': /^test(\/|\\)e2e/
      order:
        before: [
          'vendor/scripts/console-helper.js'
          'vendor/scripts/jquery-1.8.3.js'
          'vendor/scripts/angular/angular.js'
          'vendor/scripts/angular/angular-resource.min.js'
          'vendor/scripts/angular/angular-cookies.min.js'

          'vendor/scripts/bootstrap-2.2.2.js'
        ]

    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor)/
    templates:
      joinTo: 'js/templates.js'

  plugins:
    jade:
      pretty: yes # Adds pretty-indentation whitespaces to output (false by default)

  # Enable or disable minifying of result js / css files.
  # minify: true
