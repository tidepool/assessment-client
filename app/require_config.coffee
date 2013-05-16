define [], () ->
  require.config
    packages: [ 'core' ]
    paths:

      # 3rd Party Bower Libraries
      Handlebars: "../bower_components/require-handlebars-plugin/Handlebars"
      underscore: "../bower_components/underscore-amd/underscore"
      jquery: "../bower_components/jquery/jquery"
      jqueryui: "../bower_components/jquery-ui/jqueryui"
      Backbone: "../bower_components/backbone-amd/backbone"
      text: "../bower_components/requirejs-text/text"
      toastr: "../bower_components/toastr"

      # 3rd Party non-Bower Libraries
      nested_view: "scripts/vendor/nested_view"
      bootstrap: "scripts/vendor/bootstrap"
      chart: "scripts/vendor/Chart"

      # Convenience Folder Mapping
      assessments: "scripts/views/assessments"
      home: "scripts/views/home"
      dashboard: "scripts/views/dashboard"
      components: "scripts/views/components"
      results: "scripts/views/results"
      stages: "scripts/views/stages"
      user: "scripts/views/user"
      routers: "scripts/routers"
      models: "scripts/models"
      controllers: "scripts/controllers"
      collections: "scripts/collections"
      helpers: "scripts/helpers"
      messages: "scripts/views/messages"
      modelsAndCollections: "scripts/modelsAndCollections"
    shim:
      bootstrap:
        deps: ["jquery"]
        exports: "jquery"
      chart:
        exports: "Chart"

