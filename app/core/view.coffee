
define [
  'underscore'
  'backbone'
  './layouts/layout-site'
  './layouts/layout-game'
  './layouts/layout-dashboard'
  'ui_widgets/user_menu'
  'composite_views/perch'
  'bootstrap' # someone, anyone, has to include it
],
(
  _
  Backbone
  SiteLayout
  GameLayout
  DashLayout
  userMenu
  perch
) ->

  _me = 'core/view'
  _navSel = '.mainNav'
#  _TYPES =
#    site: 'SiteLayout'
#    game: 'GameLayout'
#    dash: 'DashLayout'

  Me = Backbone.View.extend

    initialize: ->
      #@setElement('body')
      $('body').append @el
      userMenu.start @options.app

    render: ()->
      #console.log "#{_me}.render() #{@_curView.className}"
      @_curLayout.show @_curView
      @$el.html @_curLayout.el
      @

    _cleanupOldView: ->
      perch.hide()
      @_curView?.close?()
      @_curView?.remove()

    _loadView: (module) ->
      #console.log "#{_me}._loadView(#{module})"
      require [
        module
      ],
      (
        ViewClass
      ) =>
        #console.log "#{_me}.require().loaded new page"
        @_cleanupOldView()
        @_curView = new ViewClass()
        # Render
        @render()
        # Sometimes things need to happen after the dom insertion. Views can implement a method to hook into this.
        @_curView.onDomInsert?()
        @options.app.analytics.trackPage module


    # ------------------------------------------------------------- Public API
    asSite: (viewModuleString) ->
      #console.log "#{_me}.asSite(#{viewModuleString})"
      @_curLayout = new SiteLayout
        app: @options.app
      $('body').addClass viewModuleString.split('/').join('-')
      @_loadView viewModuleString

    asGame: (viewModuleString) ->
      #console.log "#{_me}.asGame(#{viewModuleString})"
      @_curLayout = new GameLayout
        app: @options.app
      @_loadView viewModuleString

    asDash: (viewModuleString) ->
      @_curLayout = new DashLayout
        app: @options.app
      @_loadView viewModuleString

  Me
