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
      throw new Error('Need options.app') unless @options.app?
      @tmpl = Handlebars.compile tmpl
      @listenTo @model, 'sync', @close
      @listenTo @model, 'invalid', @_onModelInvalid
      @listenTo @model, 'error', @_onModelError

    render: ->
      @$el.html @tmpl()
      @


    # ----------------------------------------------------------- Helper Methods
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
      @model.set formData,
        silent: true
      if @model.isValid()
        if @model.isNew()
          @options.app.session.register()
        else
          @options.app.session.signIn()

    _onModelInvalid: (model, msg) ->
      @_showErr msg
      holdPlease.hide _submitSel

    _onModelError: (model, xhr, options) ->
      @_showErr "#{xhr.status}: #{xhr.statusText}"
      holdPlease.hide _submitSel



    # ----------------------------------------------------------- Public API
    show: -> @render().$el.modal 'show'

    close: -> @$el.modal 'hide'


  LoginDialog