

define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'text!./profile.hbs'
  'ui_widgets/formation'
  './profile-fields'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
  'composite_views/perch'
],
(
  $
  _
  Backbone
  Handlebars
  tmpl
  Formation
  profileFields
  holdPlease
  psst
  perch
) ->

  _me = 'forms/profile/user_profile'
  _submitBtnSel = '[type=submit]'
  _errorHolderSel = '.formation .buttonArea'
  _errorHolderMarkup = "<div id='ProfileErrorHolder'></div>"
  _tmpl = Handlebars.compile tmpl

  ProfileDialog = Backbone.View.extend

    className: 'userProfile'
    events:
      'submit form': 'onSubmit'
      'input change': 'onInputChange'


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @listenTo @model, 'error', @onError
      @listenTo @model, 'invalid', @onInvalid
      @listenTo @model, 'sync', @onSync

    render: ->
      @$el.html _tmpl @model.attributes
      @form = new Formation
        data: profileFields
        values: @model.attributes
        submitBtn:
          className: 'btn-large btn-block btn-inverse'
      @$el.append @form.render().el
      @


    # ----------------------------------------------------------- Private Helper Methods
    _showErr: (msg) ->
      psst.hide()
      psst
        sel: _errorHolderSel
        msg: msg
        type: 'error'
      holdPlease.hide @$(_submitBtnSel)



    # ----------------------------------------------------------- Event Handlers
    onInputChange: -> psst.hide()

    onSubmit: (e) ->
      console.log "#{_me}._submitProfile()"
      e.preventDefault()
      psst.hide()
      holdPlease.show @$(_submitBtnSel)
      formData = @form.getVals()
      @model.save formData,
        wait: true # Don't update the client model until the server state is changed
        profile: true # Do the validation as a profile save not as a login

    onSync: -> perch.hide()

    onError: (model, xhr) ->
      if xhr.status is 0
        msg = 'Unknown Server Error'
      else
        msg = "#{xhr.status}: #{xhr.statusText}"
      @_showErr msg

    onInvalid: (model, msg) ->
      @_showErr msg


  ProfileDialog


