# Generated on 2013-03-26 using generator-webapp 0.1.5
"use strict"
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # Enum for target switching behavior
  TARGETS =
    dev:      'dev'
    dist:     'dist'
    research: 'research'

  timestamp = grunt.template.today('mm-dd_HHMM')

  # Configurable paths and globs
  buildConfig =
    timestamp: timestamp
    src:
      parent: 'src'
      target: 'src/static'
    dev:
      parent: '.build'
      target: ".build/#{timestamp}"
    dist:
      parent: 'dist'
      target: "dist/#{timestamp}"
    research: "../OAuthProvider/public/#{timestamp}/"
    minName: 'all-min'
    libraryCSS: 'library.css'
    sassSourceGlob: [
      "**/*.sass"
      "!bower_components/**"
    ]
    coffeeSourceGlob: [
      "**/*.coffee"
      "!**/*.spec.coffee"
      "!bower_components/**/*.coffee"
    ]
    coffeeSpecGlob: '**/*.spec.coffee'
    cssSourceGlob: [
      '<%= cfg.src.parent %>/**/*.css'
      '!<%= cfg.src.target %>/bower_components/**'
      '!<%= cfg.src.parent %>/<%= cfg.libraryCSS %>'
    ]
    bowerComponents: 'bower_components/**'
    imagesGlob: [
      'images/**/{*.png,*.jpg,*.jpeg}'
      'welcome/**/{*.png,*.jpg,*.jpeg}'
      'apple*.png'
      'favicon.ico'
    ]
    specGlob: "**/*.spec.js"
    specFile: "spec.html"







  grunt.initConfig
    cfg: buildConfig
    env: grunt.file.readJSON '.env.json'
    pkg: grunt.file.readJSON 'package.json'
    connect:
      options:
        port: 7000
        hostname: '0.0.0.0' #"localhost" # change this to '0.0.0.0' to access the server from outside
        target: "<%= grunt.option('target') %>"
        src: "<%= cfg.src.parent %>"
        dev: "<%= cfg.dev.parent %>"
        dist: "<%= cfg.dist.parent %>"
      dev:
        options:
          middleware: (connect, options) ->
            [lrSnippet, mountFolder(connect, options.dev), mountFolder(connect, options.src)]
      dist:
        options:
#          keepalive: true
          middleware: (connect, options) ->
            [lrSnippet, mountFolder(connect, options.dist)]

    open:
      devHome:
        path: "http://assessments-front.dev/"

    watch:

      appHtml:
        files: [ '<%= cfg.src.parent %>/*.html', '!<%= cfg.src.parent %>/<%= specFile %>.html' ]
        tasks: [ 'copy:html', 'includereplace' ]

      specHtml:
        files: '<%= cfg.src.parent %>/<%= specFile %>'
        tasks: [ 'exec:scribeSpecs', 'includereplace' ]

      css:
        files: '<%= cfg.cssSourceGlob %>'
        tasks: 'combineCSS'

      app:
        files: [
          '<%= cfg.src.target %>/**/*.hbs'
          '<%= cfg.src.target %>/**/*.js'
        ]
        tasks: 'livereload'

      deployedFiles:
        files: [
          "<%= grunt.option('targetParent') %>/*.html"
          "<%= grunt.option('targetParent') %>/scout.js"
          "<%= grunt.option('target') %>/<%= cfg.minName %>.css"
          "<%= grunt.option('target') %>/<%= cfg.minName %>.js"
#          "<%= grunt.option('target') %>/**/*.js"
#          "<%= grunt.option('target') %>/**/*.hbs"
#          "<%= grunt.option('target') %>/**/*.{png,jpg}"
        ]
        tasks: 'livereload'

    clean:
      target: "<%= grunt.option('target') %>"
      dev:    "<%= cfg.dev.parent %>"
      dist:   "<%= cfg.dist.parent %>"
#      hbs:  "<%= cfg.temp %>/**/*.hbs"

    coffee:
      options:
        bare: true
        sourceMap: true
      cup:
        files: [
          expand: true
          cwd:  '<%= cfg.src.parent %>'
          src:  '<%= cfg.coffeeSourceGlob %>'
          dest: '<%= cfg.src.parent %>' # Create compiled files as siblings of source files
          ext:  '.js'
        ]
      spec:
        options: sourceMap: false
        files: [
          expand: true
          cwd:  '<%= cfg.src.target %>'
          src:  '<%= cfg.coffeeSpecGlob %>'
          dest: '<%= cfg.src.target %>'
          ext:  '.spec.js'
        ]

    sass:
      quatch:
        options:
          lineNumbers: true #TODO switch on targets and use this to decide whether to add line numbers or not
#          sourcemap: true #Requires Sass 3.3.0, which can be installed with gem install sass --pre
#          trace: true
          style: 'compact'
        files: [
          expand: true
          cwd:  '<%= cfg.src.parent %>'
          src:  '<%= cfg.sassSourceGlob %>'
          dest: '<%= cfg.src.parent %>' # Create css files as siblings of sass files
          ext:  '.css'
        ]

    concat:
      enate:
        src: '<%= cfg.cssSourceGlob %>'
        dest: "<%= grunt.option('target') %>/<%= cfg.minName %>.css"

    cssmin:
      ify:
        options: report: 'min'
        files: "<%= grunt.option('target') %>/<%= cfg.minName %>.css": "<%= grunt.option('target') %>/<%= cfg.minName %>.css"


    # https://github.com/jrburke/r.js/blob/master/build/example.build.js
    requirejs:
      allInOne:
        options:
          mainConfigFile: "<%= cfg.src.parent %>/_require_config.js"
          skipDirOptimize: true # don't optimize non AMD files in the dir
          name: 'core'
          include: [
            'pages/dashboard/mood'
            'pages/dashboard/personality'
            'pages/dashboard/productivity'
            'pages/dashboard/summary'
            'pages/about'
            'pages/demographics'
            'pages/error'
            'pages/friend_survey'
            'pages/game_results'
            'pages/home'
            'pages/play_game'
            'pages/social_results'
            'pages/team'
          ]
          paths:
            jquery: 'empty:' #http://requirejs.org/docs/optimization.html#empty
            bootstrap: 'empty:'
          out: '<%= grunt.option("target") %>/core/main.js'
          optimize: "uglify2"
          #optimize: "none"
          generateSourceMaps: true
          preserveLicenseComments: false
          skipPragmas: true # we don't use them, and they may slow the build

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
          timestamp:           "<%= cfg.timestamp %>"
          buildDir:            "<%= cfg.timestamp %>"
        prefix: '@@'
      config:
        files: [
          expand: true
          flatten: true
          src: '<%= cfg.src.target %>/core/config.js'
          dest: "<%= grunt.option('target') %>/core/"
        ]
      html:
        files: [
          expand: true
#          flatten: true
          cwd: "<%= grunt.option('targetParent') %>"
          src: "*.html"
          dest: "<%= grunt.option('targetParent') %>"
        ]


    includereplace:
      targetParent:
        options:
          includesDir: '<%= cfg.src.parent %>'
        files: [
          expand: true
          cwd: "<%= grunt.option('targetParent') %>"
          src: '*.html'
          dest: "<%= grunt.option('targetParent') %>"
        ]
    copy:
      html:
        files: [
          expand: true
          cwd: "<%= cfg.src.parent %>"
          src: '{index.html,library.html}'
          dest: "<%= grunt.option('targetParent') %>"
        ]
      dist:
        files: [
          expand: true
          cwd: "<%= cfg.src.target %>"
          dest: "<%= grunt.option('target') %>"
          src: [
            "require_config.js"
            "<%= cfg.horseAndBuggyJsGlob %>"
            '.htaccess'
            'library.css'
          ]
        ]
#      requireJsPrep:
#        files: [
#          expand: true
#          cwd: "<%= cfg.src.target %>"
#          dest: "<%= cfg.temp %>"
#          src: [
#            "<%= cfg.horseAndBuggyJsGlob %>"
#            "**/*.hbs"
#          ]
#        ]
#      requireJsPost:
#        files: [
#          expand: true
#          cwd: "<%= cfg.temp %>"
#          dest: "<%= cfg.dist %>"
#          src: [
#            "require_config.js"
#            "<%= cfg.horseAndBuggyJsGlob %>"
#          ]
#        ]


    aws_s3:
      options:
        accessKeyId:     '<%= env.awsKey %>'
        secretAccessKey: '<%= env.awsSecret %>'
        bucket:          '<%= env.awsBucket %>'
        region:          '<%= env.awsRegion %>'
        params:
          # Two Year cache policy (1000 * 60 * 60 * 24 * 730)#
          CacheControl: '630720000'
#          ContentType: 'application/json',
#        access: 'public-read'
        gzip: true
      deploy:
        files: [
          expand: true
          cwd: "<%= cfg.dist %>/<%= cfg.timestamp %>"
          src: '**/*.{html,js,css}' # keep it lightweight to save data transfer dollars until I get this figured out :)
          dest: '<%= cfg.timestamp %>/'
        ]

    exec:
      convert_jqueryui_amd:
        command: "jqueryui-amd <%= cfg.src.target %>/bower_components/jquery-ui"
        stdout: true

      unitTest:
        command: "node_modules/phantomjs/bin/phantomjs resources/run.js http://localhost:<%= connect.options.port %>/<%= cfg.specFile %>"

      scribeSpecs:
        command: 'ruby resources/scribeAmdDependencies.rb "<%= grunt.option(\"targetParent\") %>/" "<%= cfg.src.parent %>/" "<%= cfg.specGlob %>" "<%= cfg.specFile %>" bower_components'

  grunt.renameTask "regarde", "watch"

#  grunt.registerTask "build", [
#    "clean:dev"
#    "clean:temp"
#    "exec:convert_jqueryui_amd"
#    "coffee:dev"
#    "replace:dev"
#    "coffee:spec"
#    "compass"
#    "cssmin:dev"
#    "exec:scribeDevSpecs"
#    "copy:libraryCss"
#  ]

#  grunt.registerTask "dist", [
#    "clean:dist"
#    "exec:convert_jqueryui_amd"
#    "clean:temp"
#    "compass"
#    "cssmin:dist"
#    "coffee:temp"
#    "replace:dist"
#    "copy:requireJsPrep"
#    "requirejs"
#    "copy:requireJsPost"
#    "copy:dist"
#    "clean:temp"
#  ]

  grunt.registerTask "research", [
    "dist"
    "copy:distToPublic"
  ]


  grunt.registerTask 'spec', 'exec:unitTest'

  grunt.registerTask "ds", ['dist', 'distServer']
  grunt.registerTask "t", "test"
  grunt.registerTask "default", 'server'








  # ---------------------------------------------------------------------- v2 Task Definitions

  # precompile
  # ----------
  # Turn SASS into CSS as sibling files
  # Turn Coffeescript into JS as sibling files
  # Optional to run if you preocompile SASS and Coffeescript on your dev machine
  grunt.registerTask 'precompile', [ 'sass', 'coffee' ]


  # combineCSS
  # ----------
  grunt.registerTask 'combineCSS', 'Combines css into one file. With minify if the --dist option is set.', ->
    grunt.task.run 'concat'
    grunt.task.run('cssmin') if grunt.option TARGETS.dist # only minify non-dist builds


  # build
  # -----
  # Clean the target dir
  # Merge separate css files into a single file
  # Move files from the source dir to a build dir
  # Copy markup files and parse them for replacements
  grunt.registerTask 'build', 'Clean the target and build to it', ->
    grunt.task.run [
      "exec:convert_jqueryui_amd"
      'clean:target'     # clean out the target timestamp dir
      'combineCSS'       # Merge css into a single file and put that file in the target timestamp dir
      'copy:html'        # Move all html to the target parent dir
      'exec:scribeSpecs' # find all .spec.js files and write them into spec.html
      'includereplace'   # include files and parse variables
      'replace:html'     # parse build variables in html files
    ]
    if grunt.option TARGETS.dist
      grunt.task.run 'requirejs'


  # server
  # ------
  grunt.registerTask 'server', 'Open the target folder as a web server', ->
    grunt.task.run 'livereload-start'
    if grunt.option TARGETS.dist then grunt.task.run 'connect:dist'
    else grunt.task.run 'connect:dev'
    grunt.task.run [
      'open'
      'watch'
    ]
    #return grunt.task.run(["build", "open", "connect:dist:keepalive"])  if target is "dist"


  # test
  # ----
  grunt.registerTask 'test', 'Start a server and run unit tests. build task is a prereq', [ 'connect:dev', 'exec:unitTest' ]










  # ---------------------------------------------------------------------- Task Shortcuts
  grunt.registerTask "b", [ 'build' ] # because of zsh's stupid 'build' autocorrect message
  grunt.registerTask "s", [ 'build', 'server' ]












  # Set the output path for built files.
  # Most tasks will key off this so it is a prerequisite for running any grunt task.
  setPath = ->
    if grunt.option TARGETS.dev or TARGETS.dist or TARGETS.research
      grunt.option 'target', buildConfig[grunt.option].target
      grunt.option 'targetParent', buildConfig[grunt.option].parent
    else # Default path
      grunt.option 'target', buildConfig.dev.target
      grunt.option 'targetParent', buildConfig.dev.parent
    grunt.log.writeln "Grunt output path set to: `#{grunt.option 'target'}`"
    targets = []
    targets.push target for target of TARGETS
    grunt.log.writeln "You can set targets using grunt options, such as `--dev`"
    grunt.log.writeln "Possible targets for this project: #{targets.join(', ')}"

  setPath()



