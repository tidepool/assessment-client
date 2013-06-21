

define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'text!./profile.hbs'
  'ui_widgets/formation'
  './profile-fields'
  'syphon'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
],
(
  $
  _
  Backbone
  Handlebars
  tmpl
  Formation
  profileFields
  Syphon
  holdPlease
  psst
) ->

  _me = 'forms/profile/user_profile'
  _submitBtnSel = '[type=submit]'
  _errorHolderSel = '#ProfileErrorHolder'
  _errorHolderMarkup = "<div id='ProfileErrorHolder'></div>"

  ProfileDialog = Backbone.View.extend

    className: 'userProfile'
    events:
      'submit form': '_submitProfile'
      'input change': '_onInputChange'


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @tmpl = Handlebars.compile tmpl
      @listenTo @model, 'error', @_onError
      @listenTo @model, 'invalid', @_onInvalid
      @listenTo @model, 'sync', @hide

    render: ->
      @$el.html @tmpl @model.attributes
      form = new Formation
        data: profileFields
        submitBtn:
          className: 'btn-large btn-block btn-inverse'
      @$el.append form.render().el
      @


    # ----------------------------------------------------------- Private Helper Methods


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


  ProfileDialog


