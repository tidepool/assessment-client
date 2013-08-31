define [
  'jquery'
  'backbone'
  'Handlebars'
  'syphon'
  'text!./login.hbs'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
  'composite_views/perch'
],
(
  $
  Backbone
  Handlebars
  Syphon
  tmpl
  holdPlease
  psst
  perch
) ->

  _me = "forms/user/login"
  _confirmPassSel = '#Login-confirm'
  _submitSel = '#Login-submit'
  _registerBtnSel = '#ActionRegister'
  _loginTypeSel = '#LoginType'

  LoginDialog = Backbone.View.extend
    className: "loginDialog"
    events:
      "click #SignInFacebook": "_clickedSignInFacebook"
      "click #ActionSignIn": "_modeSignIn"
      "click #ActionRegister": "_modeRegister"
      "click #Login-forgot": "_clickedForgotPass"
      "focus input": "_jazzifySubmitBtn"
      "submit": "_submittedForm"


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      throw new Error('Need options.app and a model') unless @options.app? and @model?
      @listenTo @model, 'sync', @_onSync
      @listenTo @model, 'invalid', @_onModelInvalid
      @listenTo @model, 'error', @_onModelError

    render: ->
      @$el.html tmpl
      @options.app.analytics?.track @className, 'show'
      if @options.register
        @$(_registerBtnSel).trigger 'click'
        @$(_registerBtnSel).siblings().removeClass 'active'
        @$(_registerBtnSel).addClass 'active'
      @


    # ----------------------------------------------------------- Helper Methods
    _jazzifySubmitBtn: ->
      @$(_submitSel).addClass('btn-inverse')

    _showErr: (msg) ->
      msg = msg || 'Unknown Error'
      psst.hide()
      psst
        sel: "#LoginErrorHolder"
        msg: msg
        type: 'error'


    # ----------------------------------------------------------- Event Handlers
    _clickedSignInFacebook: (e) ->
      @options.app.session.oauth 'facebook'
      holdPlease.show $(e.target)
      @options.app.analytics?.track @className, 'Pressed Facebook Sign In'

    _clickedForgotPass: ->
#      console.log "#{_me}._clickedForgotPass()"

    _modeSignIn: ->
      @_isRegisterMode = false
      @$(_loginTypeSel).val 'signIn'
      @$(_confirmPassSel).hide()
      @_jazzifySubmitBtn()
      psst.hide()
      @options.app.analytics?.track @className, 'modeSignIn'

    _modeRegister: ->
      @_isRegisterMode = true
      @$(_loginTypeSel).val 'register'
      @$(_confirmPassSel).show()
      @_jazzifySubmitBtn()
      psst.hide()
      @options.app.analytics?.track @className, 'modeRegister'


    # ----------------------------------------------------------- Callback Handlers
    _submittedForm: (e) ->
      e.preventDefault()
      psst.hide()
      holdPlease.show _submitSel
      formData = Syphon.serialize e.target
      formData.passwordConfirm = '' unless formData.loginType == 'register'

      # Blow away the current user during registration unless it's a guest.
      @options.app.session.logOut() unless @options.app.user.isGuest()

      if formData.loginType is 'register'
#        console.log "#{_me}._submittedForm() register mode"
        @model.set formData,
          silent: true
        @options.app.session.register() if @model.isValid( register:true )
      else
#        console.log "#{_me}._submittedForm() login mode"
        @model.set formData,
          silent: true
        @options.app.session.signIn() if @model.isValid( login:true )
      @options.app.analytics?.track @className, 'Submitted Form', formData.loginType

    _onSync: ->
      perch.hide()
      @options.app.router.showDefaultPage()

    _onModelInvalid: (model, msg) ->
      @_showErr msg
      holdPlease.hide _submitSel
      @options.app.analytics?.track @className, 'Validation Issue'

    _onModelError: (model, xhr, options) ->
      msg = xhr.responseJSON?.status?.message
      msg = msg || "#{xhr.status}: #{xhr.statusText}"
      @_showErr msg
      holdPlease.hide _submitSel


  LoginDialog