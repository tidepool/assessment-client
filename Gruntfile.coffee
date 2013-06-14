# Generated on 2013-03-26 using generator-webapp 0.1.5
"use strict"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # load the server configuration from .env file
  serverConfig = {}
  require("fs").readFileSync("./.env").toString().split('\n').forEach (line) ->
    contents = line.split('=')
    console.log line
    serverConfig[contents[0]] = contents[1]

  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist"
    dev: ".devServer"
    temp: ".tmp"

  tidepoolConfig =
    sassSourceGlob: [
      "<%= yeoman.app %>/**/*.sass"
      "!<%= yeoman.app %>/bower_components/*"
    ]
    cssSourceGlob: [
      "<%= yeoman.app %>/bower_components/sass-bootstrap/bootstrap-2.3.*.css"
      "<%= yeoman.temp %>/**/*.css"
      "!<%= yeoman.temp %>/library.css"
    ]
    horseAndBuggyJsGlob: [
      "bower_components/**/{*.js,*.css}"
      "bower_components_ext/*.js"
      "scripts/vendor/*.js"
    ]
    handlebarsGlob: [
      "**/*.hbs"
    ]
    imagesGlob: [
      "images/**/{*.png,*.jpg,*.jpeg}"
    ]
    specGlob: "**/*.spec.js"
    specFile: "spec.html"

  grunt.initConfig
    yeoman: yeomanConfig
    tidepool: tidepoolConfig
    tidepoolServer: serverConfig
    bowerPkg: grunt.file.readJSON 'bower.json'
    nodePkg: grunt.file.readJSON 'package.json'
    connect:
      options:
        port: 7000
        hostname: "localhost" # change this to '0.0.0.0' to access the server from outside
      livereload:
        options:
          middleware: (connect) ->
            # A grunt variable does not work here
            [lrSnippet, mountFolder(connect, ".devServer"), mountFolder(connect, "app")]
      dist:
        options:
          keepalive: true
          middleware: (connect) ->
            [mountFolder(connect, "dist")]

    open:
      devHome:
        path: "http://assessments-front.dev/"

    watch:
      hbs:
        files: ["<%= yeoman.app %>/**/*.hbs"]
        tasks: ["livereload"]

      coffee:
        files: ["<%= yeoman.app %>/**/*.coffee"]
        tasks: ["coffee:dev", "replace:dev"]

      coffeeTest:
        files: ["<%= yeoman.app %>/**/*.spec.coffee"]
        tasks: ["coffee:spec"]

      specScribe:
        files: ["<%= yeoman.app %>/spec.html", "<%= tidepool.specGlob %>"]
        tasks: ["exec:scribeSpecs", "livereload"]

      compass:
        files: "<%= tidepool.sassSourceGlob %>"
        tasks: ["compass", "cssmin:dev", "clean:temp", "livereload"]

      libraryCss:
        files: "<%= yeoman.temp %>/library.css"
        tasks: "copy:libraryCss"

      livereload:
        files: [
          "<%= yeoman.app %>/*.html"
          "<%= yeoman.dev %>/spec.html"
          "<%= yeoman.dev %>/**/*.css"
          "<%= yeoman.app %>/library.css"
          "<%= yeoman.dev %>/**/*.js"
          "<%= yeoman.app %>/**/*.{png,jpg}"
        ]
        tasks: ["livereload"]

    clean:
      dev: ["<%= yeoman.dev %>", "<%= yeoman.temp %>", ".grunt"]
      temp: "<%= yeoman.temp %>"
      dist: "<%= yeoman.dist %>"
      hbs: "<%= yeoman.temp %>/**/*.hbs"

    coffee:
      options:
        bare: true
      temp:
          files: [
            expand: true
            cwd: "<%= yeoman.app %>"
            src: ["**/*.coffee", "!**/*.spec.coffee", "!bower_components/**/*.coffee"]
            dest: "<%= yeoman.temp %>"
            ext: ".js"
          ]
      dev:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: ["**/*.coffee", "!**/*.spec.coffee", "!bower_components/**/*.coffee"]
          dest: "<%= yeoman.dev %>"
          ext: ".js"
        ]
      spec:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "**/*.spec.coffee"
          dest: "<%= yeoman.dev %>"
          ext: ".spec.js"
        ]

    sass:
      dev:
        options:
          #debugInfo: true
          #lineNumbers: true
          trace: true
          style: 'compact'
        files:
          "<%= yeoman.dev %>/all-min.css": "<%= tidepool.sassSourceGlob %>"

    compass:
      sassPrep:
        options:
          sassDir: "<%= yeoman.app %>"
          specify: "<%= tidepool.sassSourceGlob %>"
          cssDir: "<%= yeoman.temp %>"
          outputStyle: "compact"
          noLineComments: true

    requirejs:
      dist:
        options:
          mainConfigFile: "<%= yeoman.temp %>/require_config.js"
          skipDirOptimize: true # don't optimize non AMD files in the dir
          name: 'core'
          include: [
            'pages/about'
            'pages/playGame'
            'pages/gameResult'
            'pages/home'
            'pages/investors'
            'pages/team'
          ]
          out: '<%= yeoman.dist %>/core/main.js'
          optimize: "uglify2"
          #optimize: "none"
          generateSourceMaps: true
          preserveLicenseComments: false

    useminPrepare:
      html: "<%= yeoman.app %>/spec.html"
      options:
        dest: "<%= yeoman.dev %>"

    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    cssmin:
      dev:
        options:
          report: 'min'
        files:
          "<%= yeoman.dev %>/all-min.css": "<%= tidepool.cssSourceGlob %>"
      dist:
        options:
          #banner: '/* Copyright 2013 TidePool, Inc */'
          report: 'min'
        files:
          "<%= yeoman.dist %>/all-min.css": "<%= tidepool.cssSourceGlob %>"

    htmlmin:
      dist:
        options: {}
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "index.html"
          dest: "<%= yeoman.dist %>"
        ]

    replace: 
      dist:
        options:
          variables: 
            APISERVER: "<%= tidepoolServer.PROD_APISERVER %>"
            APPSECRET: "<%= tidepoolServer.PROD_APPSECRET %>"
            APPID: "<%= tidepoolServer.PROD_APPID %>"
            kissKey: "<%= bowerPkg.kissKeyProd %>"
            googleAnalyticsKey: "<%= bowerPkg.googleAnalyticsKeyProd %>"
          prefix: '@@'
        files: [
          expand: true 
          flatten: true 
          src: ["<%= yeoman.temp %>/core/config.js"] 
          dest: "<%= yeoman.temp %>/core/"
        ]
      dev:
        options:
          variables: 
            'APISERVER': "<%= tidepoolServer.DEV_APISERVER %>"
            'APPSECRET' : "<%= tidepoolServer.DEV_APPSECRET %>" 
            'APPID' : "<%= tidepoolServer.DEV_APPID %>"
            kissKey: "<%= bowerPkg.kissKeyDev %>"
            googleAnalyticsKey: "<%= bowerPkg.googleAnalyticsKeyDev %>"
          prefix: '@@'
        files: [
          expand: true 
          flatten: true 
          src: ["<%= yeoman.dev %>/core/config.js"] 
          dest: "<%= yeoman.dev %>/core/"
        ]

    copy:
      devImages: #TODO: temporary, use custom builds of bootstrap/jqueryUI instead of copying in a fake image to stop the error message
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images/fake_glyphicons"
          src: "glyphicons*.png"
          dest: "<%= yeoman.dev %>/img"
        ]
      distImages: #TODO: temporary, use custom builds of bootstrap/jqueryUI instead of copying in a fake image to stop the error message
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images/fake_glyphicons"
          src: "glyphicons*.png"
          dest: "<%= yeoman.dist %>/img"
        ]
      libraryCss:
        src: "<%= yeoman.temp %>/library.css"
        dest: "<%= yeoman.app %>/library.css"
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: [
            ".htaccess"
            "*.html"
            "!spec.html"
            "*.{ico,txt}"
            #"<%= tidepool.horseAndBuggyJsGlob %>"
            #"<%= tidepool.handlebarsGlob %>"
            "<%= tidepool.imagesGlob %>"
          ]
        ]
      requireJsPrep:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.temp %>"
          src: [
            "<%= tidepool.horseAndBuggyJsGlob %>"
            "<%= tidepool.handlebarsGlob %>"
          ]
        ]
      requireJsPost:
        files: [
          expand: true
          cwd: "<%= yeoman.temp %>"
          dest: "<%= yeoman.dist %>"
          src: [
            "require_config.js"
            "<%= tidepool.horseAndBuggyJsGlob %>"
          ]
        ]


    exec:
      convert_jqueryui_amd:
        command: "jqueryui-amd <%= yeoman.app %>/bower_components/jquery-ui"
        stdout: true

      unitTest:
        command: "node_modules/phantomjs/bin/phantomjs resources/run.js http://localhost:<%= connect.options.port %>/<%= tidepool.specFile %>"

      scribeSpecs:
        command: 'ruby resources/scribeAmdDependencies.rb "<%= yeoman.dev %>/" "<%= yeoman.app %>/" "<%= tidepool.specGlob %>" "<%= tidepool.specFile %>"'

  grunt.renameTask "regarde", "watch"

  grunt.registerTask "build", [
    "clean:dev"
    "clean:temp"
    "exec:convert_jqueryui_amd"
    "copy:devImages"
    "coffee:dev"
    "replace:dev"
    "coffee:spec"
    "compass"
    "cssmin:dev"
    "exec:scribeSpecs"
    "copy:libraryCss"
  ]

  grunt.registerTask "devServer", [
    "livereload-start"
    "connect:livereload"
  ]
  grunt.registerTask 'distServer', [
    'open'
    'connect:dist'
  ]

  grunt.registerTask "server", (target) ->
    return grunt.task.run(["build", "open", "connect:dist:keepalive"])  if target is "dist"
    grunt.task.run [
      "build"
      "devServer"
      "open"
      "watch"
    ]

  grunt.registerTask "test", [
    "build"
    "devServer"
    "exec:unitTest"
  ]

  grunt.registerTask "dist", [
    "clean:dist"
    "exec:convert_jqueryui_amd"
    "clean:temp"
    "compass"
    "cssmin:dist"
    "coffee:temp"
    "replace:dist"
    "copy:requireJsPrep"
    "requirejs"
    "copy:requireJsPost"
    "copy:dist"
    "copy:distImages"
    "htmlmin"
    "clean:temp"
  ]

  grunt.registerTask "default", ["test", "open", "watch"]
  grunt.registerTask "s", "server"
  grunt.registerTask "t", "test"

