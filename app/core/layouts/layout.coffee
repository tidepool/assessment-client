
define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./layout.hbs'
  'text!ui_widgets/site_logo.hbs'
],
(
  _
  Backbone
  Handlebars
  tmpl
  markupLogo
) ->

  _me = 'core/layouts/layout'

  Me = Backbone.View.extend

    # Override these defaults in your inheriting class
    tagName: 'section'
    tmpl: Handlebars.compile tmpl

    # Private
    _cleanupChildren: ->
      @_curView?.close?()
      @_curView?.remove()

    # Public
    show: (view) ->
      @_cleanupChildren()
      @_curView = view
      @$('#ContentRegion').html @_curView.render().el

    close: ->
      @_cleanupChildren()

    resetHeader: -> @$('#HeaderRegion').html markupLogo

  Me

