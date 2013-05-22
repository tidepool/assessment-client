
define [
  'underscore'
  'Backbone'
  './layouts/layout-site'
  './layouts/layout-game'
],
(
  _
  Backbone
  SiteLayout
  GameLayout
) ->

  _me = 'core/view'

  Me = Backbone.View.extend

    initialize: ->
      @setElement('body')
      @_siteLayout = new SiteLayout
        app: @options.app
      @_gameLayout = new GameLayout
        app: @options.app

    render: ()->
      console.log "#{_me}.render() #{@_curView.className}"
      @_curLayout.show @_curView
      @$el.html @_curLayout.el
      @

    _loadView: (module) ->
      require [
        module
      ],
      (
        ViewClass
      ) =>
        console.log "#{_me}.require().loaded new page"
        # Cleanup
        @_curView?.close?()
        @_curView?.remove()
        # Instantiate
        @_curView = new ViewClass()
        # Render
        @render()


    # ----------------------------------------- Public API
    asSite: (viewModuleString) ->
      console.log "#{_me}.asSite(#{viewModuleString})"
      @_curLayout = @_siteLayout
      @_loadView(viewModuleString)

    asGame: (viewModuleString) ->
      console.log "#{_me}.asGame(#{viewModuleString})"
      @_curLayout = @_gameLayout
      @_loadView(viewModuleString)

  Me
