
define [
  'underscore'
  'backbone'
  './layouts/layout-site'
  './layouts/layout-game'
  './layouts/layout-dashboard'
  'ui_widgets/user_menu'
  'ui_widgets/hold_please'
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
  holdPlease
  perch
) ->

  _me = 'core/view'
  _companyName = 'TidePool'
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

    _showLoader: -> holdPlease.show null, true
    _hideLoader: -> holdPlease.hide()

    _loadView: (module, data, showLoader) ->
      @_cleanupOldView()
      @_showLoader() if showLoader
      #console.log "#{_me}._loadView(#{module})"
      require [
        module
      ],
      (
        ViewClass
      ) =>
        @_hideLoader()
        # Start the view with a model if one was provided
        if data?.model
          @_curView = new ViewClass
            model: data.model
        else
          @_curView = new ViewClass
            params: data
        # Render
        @render()
        # Sometimes things need to happen after the dom insertion. Views can implement a method to hook into this.
        @_curView.onDomInsert?()
        # Let's keep the window title matching the current page
        if @_curView.title
          document.title = "#{_.result(@_curView, 'title')} - #{_companyName}"
        else
          document.title = _companyName
        @options.app.analytics.trackPage module



    # ------------------------------------------------------------- Public API
    asSite: (viewModuleString, data) ->
      @_curLayout = new SiteLayout
        app: @options.app
      $('body').addClass viewModuleString.split('/').join('-')
      @_loadView viewModuleString, data

    asGame: (viewModuleString, data) ->
      @_curLayout = new GameLayout
        app: @options.app
      @_loadView viewModuleString, data, true

    asDash: (viewModuleString, data) ->
      @_curLayout = new DashLayout
        app: @options.app
      @_loadView viewModuleString, data

  Me
