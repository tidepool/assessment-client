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
      @listenTo @model, 'sync', @_onSync
      @_show()

    render: ->
      @$el.html @tmpl @model.attributes
      @


    # ----------------------------------------------------------- Private Helper Methods
    _show: ->
      perch.show
        title: 'Profile'
        content: @
        btn1: null


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

    _onSync: (model, data) ->
      console.log("#{_me}._onSync()")
      perch.hide()

    _onError: (model, xhr) ->
      #console.log "#{_me}._onError()"
      holdPlease.hide @$(_submitBtnSel)
      if xhr.status is 0
        msg = 'Unknown Server Error'
      else
        msg = "#{xhr.status}: #{xhr.statusText}"
      psst
        sel: _errorHolderSel
        msg: msg
        type: 'error'


    # ----------------------------------------------------------- Public API
    hide: -> perch.hide()


  ProfileDialog
