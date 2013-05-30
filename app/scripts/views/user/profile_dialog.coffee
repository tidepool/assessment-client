define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'text!./profile_dialog.hbs'
  'syphon'
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
  tmpl
  Syphon
  holdPlease
  psst
  perch
) ->

  _me = 'views/user/profile_dialog'
  _submitBtnSel = '[type=submit]'
  _errorHolderSel = '#ProfileErrorHolder'

  ProfileDialog = Backbone.View.extend

    className: 'profileDialog'
    events:
      'submit form': '_submitProfile'
      'input change': '_onInputChange'


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @tmpl = Handlebars.compile tmpl
      @listenTo @model, 'error', @_onError
      @listenTo @model, 'invalid', @_onInvalid
      @listenTo @model, 'sync', @hide
      @_show()

    render: ->
      @$el.html @tmpl @model.attributes
      @


    # ----------------------------------------------------------- Private Helper Methods
    _show: ->
      perch.show
        title: 'Profile'
        content: @
        btn1Text: null


    # ----------------------------------------------------------- Event Handlers
    _onInputChange: ->
      psst.hide()

    _submitProfile: (e) ->
      console.log "#{_me}._submitProfile()"
      e.preventDefault()
      psst.hide()
      holdPlease.show @$(_submitBtnSel)
      formData = Syphon.serialize e.target
      @model.save formData,
        wait: true # Don't update the client model until the server state is changed
        validateProfile: true # Do the validation as a profile save not as a login

    _showErr: (msg) ->
      psst.hide()
      psst
        sel: _errorHolderSel
        msg: msg
        type: 'error'
      holdPlease.hide @$(_submitBtnSel)

    _onError: (model, xhr) ->
      if xhr.status is 0
        msg = 'Unknown Server Error'
      else
        msg = "#{xhr.status}: #{xhr.statusText}"
      @_showErr msg

    _onInvalid: (model, msg) ->
      @_showErr msg




    # ----------------------------------------------------------- Public API
    hide: -> perch.hide()


  ProfileDialog
