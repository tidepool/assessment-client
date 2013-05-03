define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars',
  'user/signup_dialog',
  "text!./login_dialog.hbs",
  'controllers/session_controller'], ($, _, Backbone, Handlebars, SignupDialog, tempfile) ->
  LoginDialog = Backbone.View.extend  
    events:
      "click #facebook-login": "facebookLogin"
      "click #fitbit-login": "fitbitLogin"
      "submit #signin-form": "signin"
      "submit #signup-form": "signup"
      "click #signup": "launchSignup"
      "click #need-signup": "launchSignup"
      "click #signin": "launchSignin"
      "click #need-signin": "launchSignin"

    initialize: (options) ->
      @session = options.session

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template())
      this

    show: ->
      $("#messageView").html(@render().el)
      $("#login-dialog").modal('show')

    close: -> 
      $("#login-dialog").modal('hide')

    launchSignin: (e) ->
      e.preventDefault()
      $('.dialog-select').css('display', 'none')
      $('.dialog-signin').css('display', 'block')
      $('.dialog-signup').css('display', 'none')

    launchSignup: (e) ->
      e.preventDefault()
      $('.dialog-select').css('display', 'none')
      $('.dialog-signup').css('display', 'block')
      $('.dialog-signin').css('display', 'none')

    signin: (e) ->
      e.preventDefault()
      email = $("#email").val()
      password = $("#password").val()
      # TODO: Handle RememberMe
      rememberMe = $("#remember").val()

      @session.login(email, password)
      .done (message) =>
        $(".alert-success").css('visibility', 'visible')
        $("form #message").html(message)
      .fail (message) ->
        $(".alert-error").css('visibility', 'visible')
        $("form #message").html(message)

    signup: (e) ->
      e.preventDefault()
      email = $("#email").val()
      password = $("#password").val()
      passwordConfirm = $("#password-confirm").val()

      @session.signup(email, password, passwordConfirm)
      .done (message) =>
        $(".alert-success").css('visibility', 'visible')
        $("form #message").html(message)       
      .fail (message) ->
        $(".alert-error").css('visibility', 'visible')
        $("form #message").html(message)

    facebookLogin: (e) ->
      e.preventDefault()
      @session.loginUsingOauth('facebook', {width: 1006, height: 775})

    fitbitLogin: (e) ->
      e.preventDefault()
      @session.loginUsingOauth('fitbit', {width: 1006, height: 775})

  LoginDialog