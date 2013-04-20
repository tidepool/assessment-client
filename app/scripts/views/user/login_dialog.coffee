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
      "click #facebookLogin": "facebookLogin"
      "click #twitterLogin": "twitterLogin"
      "click #fitbitLogin": "fitbitLogin"
      "submit #loginForm": "login"
      "click #signup": "signup"

    initialize: (options) ->
      @session = options.session

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template())
      this

    login: (e) ->
      e.preventDefault()
      email = $("#email").val()
      password = $("#password").val()
      # TODO: Handle RememberMe
      rememberMe = $("#rememberMe").val()

      @session.login(email, password)
      .done (message) =>
        $(".alert-success").css('visibility', 'visible')
        $("form #message").html(message)
      .fail (message) ->
        $(".alert-error").css('visibility', 'visible')
        $("form #message").html(message)

    signup: (e) ->
      e.preventDefault()
      signupDialog = new SignupDialog({session: @session})
      $('#content').html(signupDialog.render().el)

    facebookLogin: (e) ->
      e.preventDefault()
      @session.loginUsingOauth('facebook', {width: 1006, height: 775})

    twitterLogin: (e) ->
      e.preventDefault()
      @session.loginUsingOauth('twitter', {width: 1006, height: 775})

    fitbitLogin: (e) ->
      e.preventDefault()
      @session.loginUsingOauth('fitbit', {width: 1006, height: 775})

  LoginDialog