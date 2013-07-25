# Generated on 2013-03-26 using generator-webapp 0.1.5
"use strict"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths and globs
  buildConfig =
    app: "app"
    dist: "dist"
    dev: ".devServer"
    temp: ".tmp"
    research: "../OAuthProvider/public/"
    sassSourceGlob: [
      "<%= cfg.app %>/**/*.sass"
      "!<%= cfg.app %>/bower_components/*"
    ]
    cssSourceGlob: [
#      "<%= cfg.app %>/bower_components/sass-bootstrap/bootstrap-2.3.*.css"
      "<%= cfg.app %>/styles/gfx.css"
      "<%= cfg.temp %>/**/*.css"
      "!<%= cfg.temp %>/library.css"
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
    cfg: buildConfig
    env: grunt.file.readJSON '.env.json'
    connect:
      options:
        port: 7000
        hostname: '0.0.0.0' #"localhost" # change this to '0.0.0.0' to access the server from outside
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
        files: ["<%= cfg.app %>/**/*.hbs"]
        tasks: ["livereload"]

      coffee:
        files: ["<%= cfg.app %>/**/*.coffee"]
        tasks: ["coffee:dev", "replace:dev"]

      coffeeTest:
        files: ["<%= cfg.app %>/**/*.spec.coffee"]
        tasks: ["coffee:spec"]

      specScribe:
        files: ["<%= cfg.app %>/<%= cfg.specFile %>", "<%= cfg.specGlob %>"]
        tasks: ["exec:scribeDevSpecs", "livereload"]

      compass:
        files: "<%= cfg.sassSourceGlob %>"
        tasks: ["compass", "cssmin:dev", "clean:temp", "livereload"]

      libraryCss:
        files: "<%= cfg.temp %>/library.css"
        tasks: "copy:libraryCss"

      livereload:
        files: [
          "<%= cfg.app %>/*.html"
          "<%= cfg.dev %>/spec.html"
          "<%= cfg.dev %>/**/*.css"
          "<%= cfg.app %>/library.css"
          "<%= cfg.dev %>/**/*.js"
          "<%= cfg.app %>/**/*.{png,jpg}"
        ]
        tasks: ["livereload"]

    clean:
      dev: ["<%= cfg.dev %>", "<%= cfg.temp %>", ".grunt"]
      temp: "<%= cfg.temp %>"
      dist: "<%= cfg.dist %>"
      hbs: "<%= cfg.temp %>/**/*.hbs"

    coffee:
      options:
        bare: true
      temp:
          files: [
            expand: true
            cwd: "<%= cfg.app %>"
            src: ["**/*.coffee", "!**/*.spec.coffee", "!bower_components/**/*.coffee"]
            dest: "<%= cfg.temp %>"
            ext: ".js"
          ]
      dev:
        files: [
          expand: true
          cwd: "<%= cfg.app %>"
          src: ["**/*.coffee", "!**/*.spec.coffee", "!bower_components/**/*.coffee"]
          dest: "<%= cfg.dev %>"
          ext: ".js"
        ]
      spec:
        files: [
          expand: true
          cwd: "<%= cfg.app %>"
          src: "**/*.spec.coffee"
          dest: "<%= cfg.dev %>"
          ext: ".spec.js"
        ]
      specToTemp:
        files: [
          expand: true
          cwd: "<%= cfg.app %>"
          src: "**/*.spec.coffee"
          dest: "<%= cfg.temp %>"
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
          "<%= cfg.dev %>/all-min.css": "<%= cfg.sassSourceGlob %>"

    compass:
      sassPrep:
        options:
          sassDir: "<%= cfg.app %>"
          specify: "<%= cfg.sassSourceGlob %>"
          cssDir: "<%= cfg.temp %>"
          outputStyle: "compact"
          noLineComments: true

    # https://github.com/jrburke/r.js/blob/master/build/example.build.js
    requirejs:
      dist:
        options:
          mainConfigFile: "<%= cfg.temp %>/require_config.js"
          skipDirOptimize: true # don't optimize non AMD files in the dir
          name: 'core'
          include: [
            'pages/dashboard/mood'
            'pages/dashboard/personality'
            'pages/dashboard/productivity'
            'pages/dashboard/summary'
            'pages/about'
            'pages/demographics'
            'pages/game_results'
            'pages/home'
            'pages/play_game'
            'pages/team'
          ]
          paths:
            jquery: 'empty:' #http://requirejs.org/docs/optimization.html#empty
            bootstrap: 'empty:'
          out: '<%= cfg.dist %>/core/main.js'
          optimize: "uglify2"
          #optimize: "none"
          generateSourceMaps: true
          preserveLicenseComments: false
          skipPragmas: true # we don't use them, and they may slow the build

    useminPrepare:
      html: "<%= cfg.app %>/spec.html"
      options:
        dest: "<%= cfg.dev %>"

    usemin:
      html: ["<%= cfg.dist %>/{,*/}*.html"]
      css: ["<%= cfg.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= cfg.dist %>"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= cfg.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= cfg.dist %>/images"
        ]

    cssmin:
      dev:
        options:
          report: 'min'
        files:
          "<%= cfg.dev %>/all-min.css": "<%= cfg.cssSourceGlob %>"
      dist:
        options:
          #banner: '/* Copyright 2013 TidePool, Inc */'
          report: 'min'
        files:
          "<%= cfg.dist %>/all-min.css": "<%= cfg.cssSourceGlob %>"

    htmlmin:
      dist:
        options: {}
        files: [
          expand: true
          cwd: "<%= cfg.app %>"
          src: "index.html"
          dest: "<%= cfg.dist %>"
        ]

    replace:
      options:
        variables:
          apiServer:           "<%= env.apiServer %>"
          appSecret:           "<%= env.appSecret %>"
          appId:               "<%= env.appId %>"
          kissKey:             "<%= env.kissKey %>"
          googleAnalyticsKey:  "<%= env.googleAnalyticsKey %>"
          fbId:                "<%= env.fbId %>"
          #fbSecret:            "<%= env.fbSecret %>" # not used
          isDev:               "<%= env.isDev %>"
        prefix: '@@'
      dist:
        files: [
          expand: true
          flatten: true
          src: ["<%= cfg.temp %>/core/config.js"]
          dest: "<%= cfg.temp %>/core/"
        ]
      dev:
        files: [
          expand: true
          flatten: true
          src: ["<%= cfg.dev %>/core/config.js"]
          dest: "<%= cfg.dev %>/core/"
        ]

    copy:
      libraryCss:
        src: "<%= cfg.temp %>/library.css"
        dest: "<%= cfg.app %>/library.css"
      dist:
        files: [
          expand: true
          cwd: "<%= cfg.app %>"
          dest: "<%= cfg.dist %>"
          src: [
            "welcome/**"
            ".htaccess"
            "*.html"
            "!spec.html"
            "*.{ico,txt}"
            #"<%= cfg.horseAndBuggyJsGlob %>"
            #"<%= cfg.handlebarsGlob %>"
            "<%= cfg.imagesGlob %>"
          ]
        ]
      requireJsPrep:
        files: [
          expand: true
          cwd: "<%= cfg.app %>"
          dest: "<%= cfg.temp %>"
          src: [
            "<%= cfg.horseAndBuggyJsGlob %>"
            "<%= cfg.handlebarsGlob %>"
          ]
        ]
      requireJsPost:
        files: [
          expand: true
          cwd: "<%= cfg.temp %>"
          dest: "<%= cfg.dist %>"
          src: [
            "require_config.js"
            "<%= cfg.horseAndBuggyJsGlob %>"
          ]
        ]
      distToPublic:
        files: [
          expand: true
          cwd: "<%= cfg.dist %>"
          src: "**/*.*"
          dest: "<%= cfg.research %>"
        ]


    exec:
      convert_jqueryui_amd:
        command: "jqueryui-amd <%= cfg.app %>/bower_components/jquery-ui"
        stdout: true

      unitTest:
        command: "node_modules/phantomjs/bin/phantomjs resources/run.js http://localhost:<%= connect.options.port %>/<%= cfg.specFile %>"

      scribeDevSpecs:
        command: 'ruby resources/scribeAmdDependencies.rb "<%= cfg.dev %>/" "<%= cfg.app %>/" "<%= cfg.specGlob %>" "<%= cfg.specFile %>"'

      scribeDistSpecs:
        command: 'ruby resources/scribeAmdDependencies.rb "<%= cfg.dist %>/" "<%= cfg.app %>/" "<%= cfg.specGlob %>" "<%= cfg.specFile %>"'

  grunt.renameTask "regarde", "watch"

  grunt.registerTask "build", [
    "clean:dev"
    "clean:temp"
    "exec:convert_jqueryui_amd"
    "coffee:dev"
    "replace:dev"
    "coffee:spec"
    "compass"
    "cssmin:dev"
    "exec:scribeDevSpecs"
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
    "htmlmin"
    "clean:temp"
  ]

  grunt.registerTask "distTest", [ 'dist', 'exec:unitTest']

  grunt.registerTask "research", [
    "dist"
    "copy:distToPublic"
  ]

  grunt.registerTask 'spec', 'exec:unitTest'
  grunt.registerTask "s", "server"
  grunt.registerTask "ds", ['dist', 'distServer']
  grunt.registerTask "t", "test"
  grunt.registerTask "default", 'server'

