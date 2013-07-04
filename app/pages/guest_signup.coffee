

define [
  'backbone'
  'Handlebars'
  'text!./guest_signup.hbs'
  'text!./guest_signup_personality.hbs'
  'entities/cur_user_personality'
  'entities/user_personality_skinny'
  'ui_widgets/psst'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  tmplPersonality
  CurUserPersonality
  UserPersonalitySkinny
  psst
  app
) ->

  _coreGameId = 1
  _resultsSel = '#ResultsContainer'
  _signupSel = '#SignupContainer'

  Me = Backbone.View.extend

    tmplPersonality: Handlebars.compile tmplPersonality
    className: 'guestSignupPage'
    events:
      "click #ActionShowSignup": "onClickedSignUp"

    initialize: ->
      # Get the brief summary of the assessment
      @personalityFull = new CurUserPersonality()
      @listenTo @personalityFull, 'sync', @onSync
      @listenTo @personalityFull, 'error', @onError
      @listenTo app.user, 'sync', @onUserSync
      @personalityFull.fetch()

    render: ->
      @$el.html tmpl
      @


    # ------------------------------------------------------------------------- Private Methods
    _renderPersonalityBrief: (model) ->
      @$(_resultsSel).html @tmplPersonality model.attributes


    # ------------------------------------------------------------------------- Event Callbacks
    onSync: (model) ->
      profile = model.get 'profile_description'
      if profile?
        personalityBrief = new UserPersonalitySkinny
          name: profile.name
          one_liner: profile.one_liner
          logo_url: profile.logo_url
        @_renderPersonalityBrief(personalityBrief)
      else
        model.trigger 'error', model,
          status: 'Error'
          statusText: 'Personality returned does not have a profile_description'

    onError: (model, xhr) ->
      psst
        sel: _resultsSel
        title: "Doh."
        msg: "Trouble getting a read on your personality. #{xhr.status}: #{xhr.statusText}"
        type: psst.TYPES.error

    onClickedSignUp: ->
      app.analytics.track @className, 'Pressed Sign Up'
      app.trigger 'session:showRegister'

    onUserSync: (userModel) ->
      unless userModel.isGuest()
        app.router.navigate( 'dashboard', trigger: true )

  Me

