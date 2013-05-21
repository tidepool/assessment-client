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
  _emailSel = '#Login-email'
  _passSel = '#Login-pass'
  _confirmPassSel = '#Login-confirm'
  _submitSel = '#Login-submit'
  _rememberSel = '#Login-remember'

  LoginDialog = Backbone.View.extend
    tagName: 'aside'
    className: 'loginDialog modal small hide fade'
    events:
      "click #SignInFacebook": "_clickedSignInFacebook"
      "click #ActionSignIn": "_modeSignIn"
      "click #ActionRegister": "_modeRegister"
      "click #Login-forgot": "_clickedForgotPass"
      "focus input": "_jazzSubmitBtn"
      "submit": "_submittedForm"

    initialize: ->
      throw new Error('Need options.app and options.session') unless @options.app? and @options.session?
      @tmpl = Handlebars.compile tmpl
      @options.app.on 'session:login_success', @close, @
    render: ->
      @$el.html @tmpl()
      @
    show: ->
      $("#messageView").html @render().el
      @$el.modal 'show'
    close: ->
      @$el.modal 'hide'

    _clickedSignInFacebook: ->
      @options.session.loginUsingOauth('facebook', {width: 1006, height: 775})
    _clickedForgotPass: ->
      console.log "#{_me}._clickedForgotPass()"
    _modeSignIn: ->
      @_isRegisterMode = false
      @$(_confirmPassSel).hide()
      @_jazzSubmitBtn()
    _modeRegister: ->
      @_isRegisterMode = true
      @$(_confirmPassSel).show()
      @_jazzSubmitBtn()
    _jazzSubmitBtn: ->
      @$(_submitSel).addClass('btn-inverse')
    _submittedForm: (e, a, b) ->
      e.preventDefault()
      data = @_getVals()
      console.log "#{_me}._submittedForm()"
      console.log data
      if data.isRegisterMode
        @_register(data)
      else
        @_signIn(data)

    _getVals: ->
      {
        isRegisterMode: @_isRegisterMode
        email: @$(_emailSel).val()
        password: @$(_passSel).val()
        passwordConfirm: @$(_confirmPassSel).val()
        rememberMe: @$(_rememberSel).prop('checked')
      }

    _signIn: (data) ->
      @options.session.login(data.email, data.password)
        .done(@_callbackSuccess)
        .fail(@_callbackFail)

    _register: (data) ->
      @options.session.login(data.email, data.password, data.passwordConfirm)
        .done(@_callbackSuccess)
        .fail(@_callbackFail)

    _callbackSuccess: (message) ->
      console.log "${_me}._callbackSuccess()"
      $(".alert-success").css('visibility', 'visible')
      $("form #message").html(message)
    _callbackFail: (message) ->
      console.log "${_me}._callbackFail()"
      $(".alert-error").css('visibility', 'visible')
      $("form #message").html(message)

  LoginDialog