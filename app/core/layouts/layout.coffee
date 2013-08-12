
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
  _logoSel = '.siteLogo'
  _logoShimmerClass = 'flirt'

  Me = Backbone.View.extend

    # Override these defaults in your inheriting class
    tmpl: Handlebars.compile tmpl

    initialize: ->
      $('body').prop 'class', "background-#{@className} route-#{location.hash.split('#').join('')}"

    # Private
    _cleanupChildren: ->
      @_curView?.close?()
      @_curView?.remove()

    # Public
    show: (view) ->
      @_cleanupChildren()
      view.layout = @
      @_curView = view
      @$('#ContentRegion').html @_curView.render().el

    close: ->
      @_cleanupChildren()

    resetHeader: -> @$('#HeaderRegion').html markupLogo

    # Show the logo text briefly, then animate it away
    shimmerLogo: -> @$(_logoSel).removeClass(_logoShimmerClass).addClass _logoShimmerClass

  Me

