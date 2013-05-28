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

    initialize: -> console.log "#{_me}.initialize()"

    start: (appCoreSingleton) ->
      throw new Error('Need an options.user to start') unless appCoreSingleton.user
      @app = appCoreSingleton
      @model = @app.user
      @listenTo @model, 'change', @render
      @render()
      @

    # Because it's a singleton, this is used for unit testing
    stop: ->
      @stopListening()
      delete @app
      delete @model

    render: ->
      @app.cfg.debug && console.log "#{_me}.render()"
      userData = @_parseModel @model
      @$el.html @tmpl userData
      @

    _parseModel: (model) ->
      smplModel = _.pick model.attributes, 'nickname', 'email', 'name', 'city', 'image', 'guest'
      smplModel.name = 'Guest' if smplModel.guest
      smplModel

    _clickedLogIn: -> @app?.trigger 'session:showLogin'
    _clickedLogOut: -> @app?.trigger 'session:logOut'
    _clickedProfile: -> @app?.trigger 'session:showProfile'


  new Me()

