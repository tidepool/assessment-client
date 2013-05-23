define [
  'jquery'
  'underscore'
  'Backbone'
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

    initialize: ->
      console.log "#{_me}.initialize()"
      @model = new Backbone.Model()

    start: (appCoreSingleton) ->
      console.log "#{_me}.start()"
      @app = appCoreSingleton
      @_observeUserModel()
      #debugger
      #@listenTo @app, 'session:login_success', @_observeUserModel
      #@listenTo @app, 'session:login_fail', @_observeUserModel
      #@listenTo @app, 'session:logout_success', @_observeUserModel
      @render()
      @

    render: ->
      console.log "#{_me}.render()"
      @$el.html @tmpl @_parseModel(@model)
      @

    # TODO make the user model exist in an empty state when the app lifecycle starts.
      # This way objects like this can observe it whenever they want instead of waiting until it's available like this
    _observeUserModel: ->
      console.log "#{_me}._observeUserModel()"
      @model = @app.session.user
      #@listenTo @model, 'change', @render
      @listenTo @model, 'all', (e) -> console.log "#{_me}.model event: #{e}"
      @listenTo @model, 'change', @render
      @listenTo @model, 'sync', (model) -> console.log model.attributes
      #@render()

    _parseModel: (model) ->
      smplModel = _.pick model.attributes, 'city', 'email', 'name', 'image', 'guest'
      smplModel.name = 'Guest' if smplModel.guest
      smplModel

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

