define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'syphon'
  'text!./login_dialog.hbs'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
  'bower_components_ext/bootstrap_buttons-radio'
],
(
  $
  _
  Backbone
  Handlebars
  Syphon
  tmpl
  holdPlease
  psst
) ->
  _me = "views/user/login_dialog"
  _className = 'loginDialog'
  _confirmPassSel = '#Login-confirm'
  _submitSel = '#Login-submit'

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


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      throw new Error('Need options.app and options.session') unless @options.app? and @options.session?
      @tmpl = Handlebars.compile tmpl
      @options.app.on 'session:login_success', @close, @

    render: ->
      @$el.html @tmpl()
      @


    # ----------------------------------------------------------- Helper Methods
    _jazzifySubmitBtn: ->
      @$(_submitSel).addClass('btn-inverse')

    _logIn: (data) ->
      if data.passwordConfirm
        @options.session.register(data.email, data.password, data.passwordConfirm)
          .done(@_callbackSuccess)
          .fail(_.bind(@_callbackFail, @))
      else
        @options.session.signIn(data.email, data.password)
          .done(@_callbackSuccess)
          .fail(@_callbackFail)


    # ----------------------------------------------------------- Event Handlers
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


    # ----------------------------------------------------------- Callback Handlers
    _submittedForm: (e) ->
      e.preventDefault()
      psst.hide()
      holdPlease.show _submitSel
      formData = Syphon.serialize e.target
      formData.passwordConfirm = '' if formData.loginType == 'signIn'
      @_logIn formData

    _callbackSuccess: (msg) ->
      console.log "#{_me}._callbackSuccess(): #{msg}"

    _callbackFail: (msg) ->
      psst
        sel: "#LoginErrorHolder"
        msg: msg || 'Unknown Login Failure'
        type: 'error'
      holdPlease.hide _submitSel


    # ----------------------------------------------------------- Public API
    show: ->
      @render()
      @$el.modal 'show'

    close: ->
      @$el.modal 'hide'


  LoginDialog