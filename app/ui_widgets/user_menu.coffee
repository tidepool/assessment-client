define [
  'jquery'
  'Backbone'
  'Handlebars'
  'text!./user_menu.hbs'
],
(
  $
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'ui_widgets/user_menu'

  Me = Backbone.View.extend

    className: "userMenu"
    tmpl: Handlebars.compile tmpl
    events:
      "click #ActionShowLogin": "_clickedLogIn"
      "click #ActionLogOut": "_clickedLogOut"
      "click #ActionShowProfile": "_clickedProfile"

    initialize: ->
      console.log "#{_me}.initialize()"
      @model = new Backbone.Model()

    start: (appCoreSingleton) ->
      console.log "#{_me}.start()"
      @app = appCoreSingleton
      #@model = @app.session.user
      #@listenTo @model, 'change', @render
      @render()
      @

    render: ->
      console.log "#{_me}.render()"
      @$el.html @tmpl @model.attributes
      @

    _clickedLogIn: ->
      console.log "#{_me}._clickedLogIn()"
      @app?.trigger 'session:showLogin'
    _clickedLogOut: ->
      console.log "#{_me}._clickedLogOut()"
      @app?.trigger 'session:logOut'
    _clickedProfile: (e) ->
      console.log "#{_me}._clickedProfile()"
      @app?.trigger 'session:showProfile'




  new Me()

