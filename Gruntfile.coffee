# Generated on 2013-03-26 using generator-webapp 0.1.5
"use strict"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist"
    dev: ".devServer"
    temp: ".tmp"

  tidepoolConfig =
    sassSourceGlob: ["<%= yeoman.app %>/scripts/**/*.{scss,sass}", "<%= yeoman.app %>/styles/**/*.{scss,sass}"]
    cssSourceGlob: ["<%= yeoman.app %>/components/sass-bootstrap/bootstrap-2.3.1.css", "<%= yeoman.app %>/components/toastr/toastr.css", "<%= yeoman.temp %>/**/*.css"]
    coffeeSourceGlob: []

  grunt.initConfig
    yeoman: yeomanConfig
    tidepool: tidepoolConfig
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
          middleware: (connect) ->
            [mountFolder(connect, "dist")]

    open:
      server:
      # path: 'http://localhost:<%= connect.options.port %>'
        path: "http://assessments-front.dev/"

    watch:
      hbs:
        files: ["<%= yeoman.app %>/scripts/**/*.hbs"]
        tasks: ["livereload"]

      coffee:
        files: ["<%= yeoman.app %>/**/*.coffee"]
        tasks: ["coffee:dev"]

      coffeeTest:
        files: ["<%= yeoman.app %>/**/*.spec.coffee"]
        tasks: ["coffee:spec"]

      compass:
        files: "<%= tidepool.sassSourceGlob %>"
        tasks: ["compass", "cssmin:dev", "clean:temp", "livereload"]

      livereload:
        files: ["<%= yeoman.app %>/*.html", "{<%= yeoman.dev %>,<%= yeoman.app %>}/styles/**/*.css", "{<%= yeoman.dev %>,<%= yeoman.app %>}/scripts/**/*.js", "<%= yeoman.app %>/images/**/*.{png,jpg,jpeg,webp}"]
        tasks: ["livereload"]

    clean:
      dist: ["<%= yeoman.dev %>", "<%= yeoman.dist %>", "<%= yeoman.temp %>"]
      dev: ["<%= yeoman.dev %>", "<%= yeoman.temp %>", ".grunt"]
      temp: "<%= yeoman.temp %>"

    jshint:
      options:
        jshintrc: ".jshintrc"

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*"]

    coffee:
      options:
        bare: true

      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: ["**/*.coffee", "!**/*.spec.coffee"] # Do not include the spec files
          dest: "<%= yeoman.dev %>"
          ext: ".js"
        ]

      dev:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: ["**/*.coffee", "!components/**/*.coffee"]
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

    compass:
      options:
        sassDir: "<%= yeoman.app %>"
        specify: "<%= tidepool.sassSourceGlob %>"
        cssDir: "<%= yeoman.temp %>"

        #importPath: 'app/components',
        #relativeAssets: true,
        outputStyle: "compact"
        noLineComments: true

      compile: {}

    requirejs:
      dist:

      # Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
        options:

        # `name` and `out` is set by grunt-usemin
          #baseUrl: "app/scripts"
          optimize: "none"

          # TODO: Figure out how to make sourcemaps work with grunt-usemin
          # https://github.com/yeoman/grunt-usemin/issues/30
          #generateSourceMaps: true,
          # required to support SourceMaps
          # http://requirejs.org/docs/errors.html#sourcemapcomments
          preserveLicenseComments: false
          useStrict: true
          wrap: true

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
        files:
          "<%= yeoman.dev %>/all-min.css": "<%= tidepool.cssSourceGlob %>"

      dist:
        files:
          "<%= yeoman.dist %>/all-min.css": "<%= tidepool.cssSourceGlob %>"

    htmlmin:
      dist:
        options: {}
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "*.html"
          dest: "<%= yeoman.dist %>"
        ]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,txt}", ".htaccess", "!spec.html", "!**/*.spec.*"]
        ]

    exec:
      convert_jqueryui_amd:
        command: "jqueryui-amd <%= yeoman.app %>/components/jquery-ui"
        stdout: true

      unitTest:
        command: "node_modules/phantomjs/bin/phantomjs resources/run.js http://localhost:<%= connect.options.port %>/spec.html"
        #stdout: true

  grunt.renameTask "regarde", "watch"

  grunt.registerTask "build", [
    "clean:dev"
    "exec:convert_jqueryui_amd"
    "coffee:dev"
    "coffee:spec"
    "compass"
    "cssmin:dev"
    "clean:temp"
  ]

  grunt.registerTask "devServer", [
    "livereload-start"
    "connect:livereload"
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

  grunt.registerTask "default", ["test", "open", "watch"]
  grunt.registerTask "s", "server"
  grunt.registerTask "t", "test"