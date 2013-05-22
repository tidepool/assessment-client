
define [
  'underscore'
  'Backbone'
  'Handlebars'
  './layout'
  'ui_widgets/header'
],
(
  _
  Backbone
  Handlebars
  Layout
  Header
) ->

  _me = 'core/layouts/game'

  Me = Layout.extend
    className: 'gameLayout'

    initialize: ->
      @render()
      @header = new Header
        app: @options.app
      @$el.prepend @header.hideNav().render().el

  Me

