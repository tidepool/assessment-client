define [
  'jquery'
  'underscore'
  'Backbone'
  'Handlebars'
  'text!./login_dialog.hbs'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
],
(
  $
  _
  Backbone
  Handlebars
  tmpl
  holdPlease
  psst
) ->
  _me = "views/user/login_dialog"
  _className = 'loginDialog'
  _emailSel = '#Login-email'
  _passSel = '#Login-pass'
  _confirmPassSel = '#Login-confirm'
  _submitSel = '#Login-submit'
  _rememberSel = '#Login-remember'

  LoginDialog = Backbone.View.extend
    tagName: 'aside'
    className: "#{_className} modal small hide fade"
    events:
      "click #SignInFacebook": "_clickedSignInFacebook"
      "click #ActionSignIn": "_modeSignIn"
      "click #ActionRegister": "_modeRegister"
      "click #Login-forgot": "_clickedForgotPass"
      "focus input": "_jazzifySubmitBtn"
      "submit": "_submittedForm"

    initialize: ->
      throw new Error('Need options.app and options.session') unless @options.app? and @options.session?
      @tmpl = Handlebars.compile tmpl
      @options.app.on 'session:login_success', @close, @

    render: ->
      @$el.html @tmpl()
      @

    show: ->
      @render()
      @$el.modal 'show'

    close: ->
      @$el.modal 'hide'

    _clickedSignInFacebook: (e) ->
      @options.session.loginUsingOauth('facebook', {width: 1006, height: 775})
      holdPlease.show $(e.target)

    _clickedForgotPass: ->
      console.log "#{_me}._clickedForgotPass()"

    _modeSignIn: ->
      @_isRegisterMode = false
      @$(_confirmPassSel).hide()
      @_jazzifySubmitBtn()
      psst.hide()

    _modeRegister: ->
      @_isRegisterMode = true
      @$(_confirmPassSel).show()
      @_jazzifySubmitBtn()
      psst.hide()

    _jazzifySubmitBtn: ->
      @$(_submitSel).addClass('btn-inverse')

    _submittedForm: (e) ->
      e.preventDefault()
      psst.hide()
      holdPlease.show _submitSel
      data = @_getVals()
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
      @options.session.signIn(data.email, data.password)
        .done(@_callbackSuccess)
        .fail(@_callbackFail)

    _register: (data) ->
      @options.session.register(data.email, data.password, data.passwordConfirm)
        .done(@_callbackSuccess)
        .fail(_.bind(@_callbackFail, @))

    _callbackSuccess: (msg) ->
      console.log "#{_me}._callbackSuccess(): #{msg}"
    _callbackFail: (msg) ->
      psst
        sel: "#LoginErrorHolder"
        msg: msg || 'Unknown Login Failure'
        type: 'error'
      holdPlease.hide _submitSel

  LoginDialog