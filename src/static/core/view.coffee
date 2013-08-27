
define [
  'underscore'
  'backbone'
  './layouts/layout-site'
  './layouts/layout-game'
  './layouts/layout-dashboard'
  'ui_widgets/user_menu'
  'composite_views/perch'
  'utils/detect'
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
  detect
) ->

  _me = 'core/view'
  _companyName = 'TidePool'
  _navSel = '.mainNav'


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

    _loadView: (module, data, showLoader) ->
      @_cleanupOldView()
      #console.log "#{_me}._loadView(#{module})"
      require [
        module
      ],
      (
        ViewClass
      ) =>
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

        @scrollToTop()
        @options.app.analytics.trackPage module
        @


    # ------------------------------------------------------------- Public API
    # For mobile devices, scroll the address bar away
    scrollToTop: ->
      if detect.isPhone()
        setTimeout (-> window.scrollTo(0,1) ), 0
      @

    asSite: (viewModuleString, data) ->
      @_curLayout = new SiteLayout
        app: @options.app
      $('body').addClass viewModuleString.split('/').join('-')
      @_loadView viewModuleString, data
      @

    asGame: (viewModuleString, data) ->
      @_curLayout = new GameLayout
        app: @options.app
      @_loadView viewModuleString, data
      @

    asDash: (viewModuleString, data) ->
      @_curLayout = new DashLayout
        app: @options.app
      @_loadView viewModuleString, data
      @

  Me