define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'syphon'
  'text!./login_dialog.hbs'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
  'composite_views/perch'
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
  perch
) ->

  _me = "views/user/login_dialog"
  _confirmPassSel = '#Login-confirm'
  _submitSel = '#Login-submit'
  _registerBtnSel = '#ActionRegister'

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
      @tmpl = Handlebars.compile tmpl
      @listenTo @model, 'sync', @hide
      @listenTo @model, 'invalid', @_onModelInvalid
      @listenTo @model, 'error', @_onModelError
      @_show()
      if @options.register
        @$(_registerBtnSel).trigger 'click'
        @_modeRegister()

    render: ->
      @$el.html @tmpl()
      @


    # ----------------------------------------------------------- Helper Methods
    _show: ->
      perch.show
        content: @
        btn1Text: null

    _jazzifySubmitBtn: ->
      @$(_submitSel).addClass('btn-inverse')

    _showErr: (msg) ->
      psst.hide()
      psst
        sel: "#LoginErrorHolder"
        msg: msg || 'Unknown Error'
        type: 'error'


    # ----------------------------------------------------------- Event Handlers
    _clickedSignInFacebook: (e) ->
      @options.app.session.loginUsingOauth('facebook', {width: 1006, height: 775})
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
      formData.passwordConfirm = '' unless formData.loginType == 'register'
      @options.app.session.logOut() # Clear any existing user data
      if formData.loginType is 'register'
        console.log "#{_me}.saving register form of user model..."
        @model.set formData
        @options.app.session.register()
      else
        @model.set formData,
          silent: true
        @options.app.session.signIn()


    _onSync: (model, data) ->
      console.log("#{_me}._onSync()")
      perch.hide()

    _onModelInvalid: (model, msg) ->
      @_showErr msg
      holdPlease.hide _submitSel

    _onModelError: (model, xhr, options) ->
      @_showErr "#{xhr.status}: #{xhr.statusText}"
      holdPlease.hide _submitSel


    # ----------------------------------------------------------- Public API
    hide: -> perch.hide()


  LoginDialog