define [
  'jquery'
  'underscore'
  'Backbone'
  'Handlebars'
  "text!./login_dialog.hbs"
  'controllers/session_controller'
],
(
  $
  _
  Backbone
  Handlebars
  tmpl
) ->
  _me = "views/user/login_dialog"
  _signinToggleSel = '#SignInOrRegister'
  _confirmPassSel = '#ConfirmPassword'

  LoginDialog = Backbone.View.extend  
    events:
      "click #facebook-login": "facebookLogin"
      #"click #fitbit-login": "fitbitLogin"
      #"submit #signin-form": "signin"
      #"submit #signup-form": "signup"
      #"click #need-signup": "launchSignup"
      #"click #need-signin": "launchSignin"
      "click #SignInOrRegister": "clickedSignInOrRegister"

    initialize: (options) ->
      @session = options.session
      @tmpl = Handlebars.compile tmpl

    render: ->
      @$el.html @tmpl()
      @

    show: ->
      $("#messageView").html @render().el
      $("#login-dialog").modal('show')

    close: -> 
      $("#login-dialog").modal('hide')


    clickedSignInOrRegister: (e) ->
      $selected = @$(_signinToggleSel).find('.active')
      mode = $selected.val()
      console.log mode
      switch mode # This logic is reversed because we catch the event before the delegated bootstrap button switcher catches the event
        when 'signIn' then @modeRegister()
        when 'register' then @modeSignIn()
        else throw new Error("#{_me}: Unknown mode")

    modeSignIn: ->
      @$(_confirmPassSel).hide()

    modeRegister: ->
      @$(_confirmPassSel).show()

    signin: (e) ->
      e.preventDefault()
      email = $("#signin-form #email").val()
      password = $("#signin-form #password").val()
      # TODO: Handle RememberMe
      rememberMe = $("signin-form #remember").val()

      @session.login(email, password)
      .done (message) =>
        $(".alert-success").css('visibility', 'visible')
        $("form #message").html(message)
      .fail (message) ->
        $(".alert-error").css('visibility', 'visible')
        $("form #message").html(message)

    signup: (e) ->
      e.preventDefault()
      email = $("#signup-form #email").val()
      password = $("#signup-form #password").val()
      passwordConfirm = $("#signup-form #password-confirm").val()
      rememberMe = $("signup-form #remember").val()

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