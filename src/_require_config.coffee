# This is a partial, not an AMD module.
# It is meant to be inlined into index.html or other html files using grunt-include-replace or similar

require.config
  packages: [
    'core'
    'game/levels/_base'
    'game/levels/reaction_time_disc'
    'game/levels/person_fill'
    'game/levels/proximity_takes_turns'
    'game/levels/alex_trebek'
    'game/levels/snoozer'
    'game/levels/interest_picker'
    'ui_widgets/formation'
  ]
  paths:
    # Global CDN Libraries
    jquery:    '//ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min'
    bootstrap: '//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/js/bootstrap.min'

    # 3rd Party Bower Libraries
    Handlebars:     'bower_components/require-handlebars-plugin/Handlebars'
    underscore:     'bower_components/underscore-amd/underscore'
    jqueryui:       'bower_components/jquery-ui/jqueryui'
    jquiTouchPunch: 'bower_components/jquery-ui-touch-punch/jquery.ui.touch-punch.min'
    backbone:       'bower_components/backbone-amd/backbone'
    syphon:         'bower_components/tidepool-backbone.syphon/lib/amd/backbone.syphon'
    text:           'bower_components/requirejs-text/text'
    chart:          'bower_components/Chart.js/Chart.min'
    markdown:       'bower_components/markdown/lib/markdown'
    fastclick:      'bower_components/fastclick/lib/fastclick'

    # 3rd Party non-Bower Libraries
    nested_view: 'scripts/vendor/nested_view'

    # Convenience Folder Mapping
    results:     'scripts/views/results'
    controllers: 'scripts/controllers'
    helpers:     'scripts/helpers'

  shim:
    bootstrap:
      deps: [ 'jquery' ]
      exports: 'jquery'
    chart:
      exports: 'Chart'
    markdown:
      exports: 'markdown'

  waitSeconds: 14
