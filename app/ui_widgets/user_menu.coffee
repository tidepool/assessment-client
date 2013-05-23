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
      @model = @app.session.user
      #@listenTo @model, 'all', (e) -> console.log "#{_me}.model event: #{e}"
      @listenTo @model, 'change', @render
      @render()
      @

    render: ->
      console.log "#{_me}.render()"
      @$el.html @tmpl @_parseModel(@model)
      @

    _parseModel: (model) ->
      smplModel = _.pick model.attributes, 'city', 'email', 'name', 'image', 'guest'
      smplModel.name = 'Guest' if smplModel.guest
      smplModel

    _clickedLogIn: -> @app?.trigger 'session:showLogin'
    _clickedLogOut: -> @app?.trigger 'session:logOut'
    _clickedProfile: -> @app?.trigger 'session:showProfile'


  new Me()

