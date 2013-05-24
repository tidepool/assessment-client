define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'text!./profile_dialog.hbs'
  'syphon'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
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
) ->

  _me = 'views/user/profile_dialog'
  _submitBtnSel = '[type=submit]'
  _errorHolderSel = '#ProfileErrorHolder'

  ProfileDialog = Backbone.View.extend

    className: 'profileDialog modal small hide fade'
    events:
      'submit form': '_submitProfile'
      'input change': '_onInputChange'


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @tmpl = Handlebars.compile tmpl
      @render()

    render: ->
      @$el.html @tmpl @model.attributes
      @


    # ----------------------------------------------------------- Event Handlers
    _onInputChange: ->
      psst.hide()

    _submitProfile: (e) ->
      e.preventDefault()
      holdPlease.show @$(_submitBtnSel)
      formData = Syphon.serialize e.target
      @model.set formData
      @model.save()
      .done =>
        console.log("#{_me}._submitProfile.done()")
        holdPlease.hide @$(_submitBtnSel)
        @close()
      .fail (msg) =>
        psst
          sel: _errorHolderSel
          msg: msg || 'Unknown Error Saving Profile'
          type: 'error'
        holdPlease.hide @$(_submitBtnSel)


    # ----------------------------------------------------------- Public API
    show: -> @$el.modal('show')
    close: -> @$el.modal('hide')


  ProfileDialog
