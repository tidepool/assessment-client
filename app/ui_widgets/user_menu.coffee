define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'text!./user_menu.hbs'
],
(
  $
  _
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

    start: (appCoreSingleton) ->
      throw new Error('Need an options.user to start') unless appCoreSingleton.user
      @app = appCoreSingleton
      @model = @app.user
      #@listenTo @model, 'all', (e) -> console.log "#{_me} event: #{e}"
      @listenTo @model, 'change', @render
      @render()
      @

    # Because it's a singleton, this needed for unit testing
    stop: ->
      @stopListening()
      delete @app
      delete @model

    render: ->
      userData = @_parseModel @model
      @$el.html @tmpl userData
      @

    _parseModel: (model) ->
      _.pick model.attributes, 'nickname', 'email', 'name', 'city', 'image', 'guest'

    _clickedLogIn: -> @app?.trigger 'session:showLogin'
    _clickedLogOut: -> @app?.trigger 'session:logOut'
    _clickedProfile: -> @app?.trigger 'session:showProfile'


  new Me()

