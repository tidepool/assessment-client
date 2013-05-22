
define [
  'underscore'
  'Backbone'
  'Handlebars'
  './layout'
  'text!./layout-site.hbs'
  'ui_widgets/header'
],
(
  _
  Backbone
  Handlebars
  Layout
  tmpl
  Header
) ->

  _me = 'core/layouts/site'

  Me = Layout.extend
    className: 'siteLayout'
    tmpl: Handlebars.compile tmpl

    initialize: ->
      @render()
      @header = new Header
        app: @options.app
      @$el.prepend @header.render().el

    render: ->
      console.log "#{_me}.render()"
      @$el.html @tmpl()

  Me


