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

        # change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            # A grunt variable does not work here
            [lrSnippet, mountFolder(connect, ".devServer"), mountFolder(connect, "app")]

      test:
        options:
          middleware: (connect) ->
            [mountFolder(connect, ".devServer"), mountFolder(connect, "app")]

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
        tasks: ["coffee:test"]

      compass:
        files: "<%= tidepool.sassSourceGlob %>"
        tasks: ["compass", "cssmin:dev", "clean:temp", "livereload"]

      livereload:
        files: ["<%= yeoman.app %>/*.html", "{<%= yeoman.dev %>,<%= yeoman.app %>}/styles/**/*.css", "{<%= yeoman.dev %>,<%= yeoman.app %>}/scripts/**/*.js", "<%= yeoman.app %>/images/**/*.{png,jpg,jpeg,webp}"]
        tasks: ["livereload"]

    clean:
      dist: ["<%= yeoman.dev %>", "<%= yeoman.dist %>", "<%= yeoman.temp %>"]
      dev: ["<%= yeoman.dev %>", "<%= yeoman.temp %>"]
      temp: "<%= yeoman.temp %>"

    jshint:
      options:
        jshintrc: ".jshintrc"

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*"]

    mocha:
      all:
        options:
          timeout: 10000000 # This is a hack so the test server keeps running and we can hit browser
          # inject: "", // This makes it so that the specs don't run in PhantomJS
          mocha:
            ui: "bdd"
            ignoreLeaks: false

          run: true
          urls: ["http://localhost:<%= connect.options.port %>/spec.html"]

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
          src: "**/*.coffee"
          dest: "<%= yeoman.dev %>"
          ext: ".js"
        ]

      test:
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
          baseUrl: "app/scripts"
          optimize: "none"

          # TODO: Figure out how to make sourcemaps work with grunt-usemin
          # https://github.com/yeoman/grunt-usemin/issues/30
          #generateSourceMaps: true,
          # required to support SourceMaps
          # http://requirejs.org/docs/errors.html#sourcemapcomments
          preserveLicenseComments: false
          useStrict: true
          wrap: true


    #uglify2: {} // https://github.com/mishoo/UglifyJS2
    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"

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

        #removeCommentsFromCDATA: true,
        #                    // https://github.com/yeoman/grunt-usemin/issues/44
        #                    //collapseWhitespace: true,
        #                    collapseBooleanAttributes: true,
        #                    removeAttributeQuotes: true,
        #                    removeRedundantAttributes: true,
        #                    useShortDoctype: true,
        #                    removeEmptyAttributes: true,
        #                    removeOptionalTags: true
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

  grunt.renameTask "regarde", "watch"
  grunt.registerTask "server", (target) ->
    return grunt.task.run(["build", "open", "connect:dist:keepalive"])  if target is "dist"
    grunt.task.run ["clean:dev", "exec", "coffee:dev", "coffee:test", "compass", "cssmin:dev", "clean:temp", "livereload-start", "connect:livereload", "open", "watch"]

  grunt.registerTask "test", ["clean:dev", "exec", "coffee:dev", "coffee:test", "compass", "connect:test", "mocha"]
  grunt.registerTask "build", ["clean:dist", "exec", "coffee:dist", "compass", "cssmin:dist", "clean:temp", "useminPrepare", "requirejs", "imagemin", "htmlmin", "concat", "cssmin:dist", "uglify", "copy:dist", "usemin"]
  grunt.registerTask "default", ["jshint", "test", "build"]
  grunt.registerTask "s", "server"
  grunt.registerTask "t", "test"