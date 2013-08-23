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
    dev: 'dev'
    dist: 'dist'
    research: 'research'

  # configurable paths and globs
  buildConfig =
    app: "app"
    dist: "dist"
    temp: ".tmp"
    dev: '.devServer'
    timestamp: grunt.template.today('mm-dd_HHMM')
    research: "../OAuthProvider/public/"
    sassSourceGlob: [
      "**/*.sass"
      "!bower_components/*"
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
      "apple*.png"
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
      quatch:
        options:
#          lineNumbers: true #TODO switch on targets and use this to decide whether to add line numbers or not
#          sourcemap: true #Requires Sass 3.3.0, which can be installed with gem install sass --pre
          trace: true
          style: 'compact'
        files: [
          expand: true
          cwd:  '<%= cfg.app %>'
          src:  '<%= cfg.sassSourceGlob %>'
          dest: '<%= cfg.app %>' # Create css files as siblings of sass files
          ext:  '.css'
        ]

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

    cssmin:
      ify:
        options: report: 'min'
        files: "<%= grunt.option('target') %>/all-min.css": "<%= cfg.cssSourceGlob %>"

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




  # Set the output path for built files.
  # Most tasks will key off this so it is a prerequisite for running any grunt task.
  setPath = ->
    if grunt.option 'dev'
      grunt.option 'target', buildConfig.dev
    else if grunt.option 'dist'
      grunt.option 'target', "#{buildConfig.dist}/#{buildConfig.timestamp}"
    else # Default path
      grunt.option 'target', buildConfig.dev
    grunt.log.writeln "Output path set to: `#{grunt.option 'target'}`"
    targets = []
    targets.push target for target of TARGETS
    grunt.log.writeln "You can set targets using grunt options, such as `--dev`"
    grunt.log.writeln "Possible targets for this project: #{targets.join(', ')}"

  setPath()



#  grunt.registerTask 'setPath', 'Sets the output path', (dest) ->
#    if      dest is TARGETS.dist
#      grunt.option 'target', "#{buildConfig.dist}/#{buildConfig.timestamp}"
#    else if dest is TARGETS.dev
#      grunt.option 'target', buildConfig.dev
#    else
#      grunt.option 'target', dest
#    grunt.log.writeln "Output path set to: #{grunt.option 'target'}"


#  grunt.registerTask("setBuildType", "Set the build type. Either build or local", (val) ->
#    grunt.log.writeln val + " :setBuildType val"
#    global.buildType = val
#
#  grunt.registerTask("setOutput", "Set the output folder for the build.", ->
#    if global.buildType is 'dev'
#      global.outputPath = MACHINE_PATH
#    else if global.buildType is 'dist'
#      global.outputPath = LOCAL_PATH
#    if grunt.option "target"
#      global.outputPath = grunt.option "target"
#    grunt.option "target", global.outputPath
#    grunt.log.writeln() "Output path: " + grunt.option("target") )



