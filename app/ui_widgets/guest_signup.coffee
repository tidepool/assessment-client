

define [
  'backbone'
  'text!./guest_signup.hbs'
  'core'
], (
  Backbone
  tmpl
  app
) ->

  Me = Backbone.View.extend

    className: 'guestSignup'
    events: "click #ActionShowSignup": "onClickedSignUp"

    initialize: -> @listenTo app.user, 'sync', @onUserSync

    render: ->
      @$el.html tmpl
      return this

    onClickedSignUp: ->
      app.analytics.track @className, 'Pressed Sign Up'
      app.trigger 'session:showRegister'

    onUserSync: (userModel) ->
      unless userModel.isGuest()
        app.router.navigate( 'dashboard', trigger: true )

  Me

