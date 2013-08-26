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

  timestamp = grunt.template.today('mm-dd')
  defaultSubdir = 'static'

  # Configurable paths and globs
  buildConfig =
    timestamp: timestamp
    src:
      parent: 'src'
      target: "src/#{defaultSubdir}"
      subdir: defaultSubdir
    dev:
      parent: '.build'
      target: ".build/#{defaultSubdir}"
      subdir: defaultSubdir
    dist:
      parent: 'dist'
      target: "dist/#{timestamp}"
      subdir: timestamp
    research: "../OAuthProvider/public/#{timestamp}/"
    minName: 'all-min'
    libraryCSS: 'library.css'
    hbsSourceGlob: [
      "**/*.hbs"
      "!bower_components/**"
    ]
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
    bowerComponents: 'src/static/bower_components'
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
      oneForAll:
        options:
          baseUrl: "<%= cfg.src.parent %>/static" #"<%= grunt.option('targetSubdir') %>"
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
#          out: '<%= grunt.option("target") %>/core/main.js'
          out: '<%= grunt.option("target") %>/all-min.js'
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
          buildDir:            "<%= grunt.option('targetSubdir') %>"
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
          src: "{*.html,**/*.hbs}"
          dest: "<%= grunt.option('targetParent') %>"
        ]


    includereplace:
      targetParent:
        options:
          includesDir: '<%= cfg.src.parent %>'
          globals:
            buildDir: "<%= grunt.option('targetSubdir') %>"
        files: [
          expand: true
          cwd: "<%= grunt.option('targetParent') %>"
          src: '*.html'
          dest: "<%= grunt.option('targetParent') %>"
        ]
    copy:
      bower: files: [
        expand: true
        cwd: "<%= cfg.src.target %>/bower_components"
        src: '**/*.*'
        dest: "<%= grunt.option('target') %>/bower_components"
      ]
      hbs:
        files: [
          expand: true
          cwd: "<%= cfg.src.target %>"
          src: "<%= cfg.hbsSourceGlob %>"
          dest: "<%= grunt.option('target') %>"
        ]
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

    'git-describe':
      options:
        prop: 'meta.revision'
      me: {}


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

      unitTest:
        command: "node_modules/phantomjs/bin/phantomjs resources/run.js http://localhost:<%= connect.options.port %>/<%= cfg.specFile %>"

      scribeSpecs:
        command: 'ruby resources/scribeAmdDependencies.rb "<%= grunt.option(\"targetParent\") %>/" "<%= cfg.src.parent %>/" "<%= cfg.specGlob %>" "<%= cfg.specFile %>" bower_components'

  grunt.renameTask "regarde", "watch"












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
      'copy:bower'       # Copy bower dependencies to the target timestamp dir
      'copy:html'        # Move all html to the target parent dir
      'copy:hbs'         # Copy all hbs templates to the target dir. Necessary so that we can replace @@buildDir for image references
      'exec:scribeSpecs' # find all .spec.js files and write them into spec.html
      'includereplace'   # include files and parse variables
      'replace:html'     # parse build variables in html files
      'replace:config'   # replace build values
    ]
    if grunt.option TARGETS.dist
      grunt.log.writeln "Building in Dist Mode"
      grunt.task.run 'requirejs'
    else
      grunt.log.writeln "Building in Dev Mode"
#      grunt.task.run [
#
#      ]

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





  grunt.registerTask 'logRev', ->
    grunt.event.once 'git-describe', (rev) ->
      grunt.log.writeln "Git Revision: #{rev}"
      grunt.option 'gitRevision', rev
    grunt.task.run 'git-describe'
#    grunt.log.write("Describe current commit: ")
#    grunt.util.spawn {
#      cmd: "git",
#      args: [ "describe", "--tags", "--always", "--long", "--dirty" ]
#    }, (err, result) ->
#      if err
#        grunt.log.error err
#        return done false
#      grunt.config('revision', result)
#      grunt.log.writeln result
#      done result



  # ---------------------------------------------------------------------- Task Shortcuts
  grunt.registerTask "b", [ 'build' ] # because of zsh's stupid 'build' autocorrect message
  grunt.registerTask "s", [ 'build', 'server' ]
  grunt.registerTask 'spec', 'exec:unitTest'
  grunt.registerTask "default", 's'










  # Set the output path for built files.
  # Most tasks will key off this so it is a prerequisite for running any grunt task.
  setPath = (gitRevision) ->
    hash = '_' + gitRevision[0]
    grunt.option 'gitRevision', hash
    targetInfo = buildConfig.dev # Default path
    if grunt.option TARGETS.dev
      targetInfo = buildConfig.dev
    else if grunt.option TARGETS.dist
      targetInfo = buildConfig.dist
    else
      grunt.option TARGETS.dev, true

    grunt.option 'target',       targetInfo.target + hash
    grunt.option 'targetParent', targetInfo.parent
    grunt.option 'targetSubdir', targetInfo.subdir + hash
    grunt.log.writeln "Output path set to: #{grunt.option 'target'}"
    grunt.log.writeln "Parent path:        #{grunt.option 'targetParent'}"
    grunt.log.writeln "Subdir:             #{grunt.option 'targetSubdir'}"
    targets = []
    targets.push target for target of TARGETS
    grunt.log.writeln "You can set targets using grunt options, such as `--dev`"
    grunt.log.writeln "Possible targets for this project: #{targets.join(', ')}"

  grunt.event.once 'git-describe', setPath
  grunt.task.run 'git-describe'
#  setPath()



