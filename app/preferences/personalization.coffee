

define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'text!./personalization.hbs'
  'text!./personalization-games.hbs'
  'ui_widgets/formation'
  './personalization-fields-productivity'
  './personalization-fields-mood'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
  'composite_views/perch'
  'core'
],
(
  $
  _
  Backbone
  Handlebars
  tmpl
  tmplGames
  Formation
  fields1
  fields2
  holdPlease
  psst
  perch
  app
) ->

  _btnSel = '.actionZone .btn'
#  _errorHolderSel = '.formation .buttonArea'
  _contentSel = '.content'
  _stepsSel = '.stepsRemainingWizard li'
  _completedClass = 'complete'
  _tmpl = Handlebars.compile tmpl
  _fields = [
    fields1
    fields2
  ]
  _titles = [
    '1. Productivity'
    '2. Mood'
  ]
  _infoTips = [
    'TidePool\'s patented exercises are designed by top American psychologists.'
    'Many TidePool users report positive results and also shared TidePool with friends and family.'
    'TidePool games will improve your self-awareness and coach you to achieve your goals.'
  ]
  _infoSel = '.footer'
  _infoTmpl = Handlebars.compile '<i class="icon-info-sign"></i> &nbsp; {{text}}'
  _explanationSel = '.explanation'
  _explanationTmpl = Handlebars.compile '<h3>{{title}}</h3><p class="small">{{subtitle}}</p>'


  ProfileDialog = Backbone.View.extend

    className: 'personalization'
    events:
      'click #ActionNext': 'onClickNext'
      'submit form': 'onSubmit'
      'input change': 'onInputChange'
      'click .games a': 'onGameClicked'


  # ----------------------------------------------------------- Backbone Methods
    initialize: ->
#      @listenTo @model, 'error', @onError
#      @listenTo @model, 'invalid', @onInvalid
#      @listenTo @model, 'sync', @onSync
      @_createInitialData() # Makes the user preferences thing, just in case they don't have them yet
      @curPage = 0

    render: ->
      @$el.html _tmpl #@model.attributes
      @_showFields(@curPage)
      @


    # ----------------------------------------------------------- Private Helper Methods
    _showFields: (idx) ->
      @_indexActions idx
      # Form Explanation
      @$(_explanationSel).html _explanationTmpl
        title: _titles[idx]
        subtitle: 'Select all options that you are interested to improve.'
      # Form Fields
      @form = new Formation data: _fields[idx]
      @$(_contentSel).html @form.render().el
      @

    _getData: ->
      return unless @form?
      formData = @form.getVals()
      @data = @data || {}
      @data = _.extend @data, formData
      console.log
        formData:formData
        allData:@data
      @

    _indexActions: (idx) ->
      @$(_stepsSel).eq(idx).addClass _completedClass
      @$(_infoSel).html _infoTmpl { text: _infoTips[idx] }

    _showComplete: (idx) ->
      @_indexActions idx
      @$(_explanationSel).html _explanationTmpl
        title: 'Your Personalized Program is ready!'
        subtitle: 'You can go back at any time and change your preferences.'
      @$(_contentSel).html tmplGames
      @$(_btnSel).remove()
      @

    #TODO: Fix this it sucks
    _createInitialData: ->
      $.ajax
        type: 'POST'
        contentType: 'application/json'
        data: JSON.stringify
          type: 'TrainingPreference'
          data: { seed: 42 }
        url: "#{window.apiServerUrl}/api/v1/users/-/preferences" #TODO: remove window reference, use app.cfg instead
      @

    _sendData: ->
      return unless @data?
      $.ajax
        type: 'PUT'
        contentType: 'application/json'
        data: JSON.stringify
          type: 'TrainingPreference'
          data: @data
        url: "#{window.apiServerUrl}/api/v1/users/-/preferences" #TODO: remove window reference, use app.cfg instead
      @

    _showErr: (msg) ->
      psst.hide()
      psst
        sel: _errorHolderSel
        msg: msg
        type: 'error'
      holdPlease.hide @$(_submitBtnSel)


    # ----------------------------------------------------------- Event Handlers
# TODO: Bind to server
#    onInputChange: -> psst.hide()
#
#    onSubmit: (e) ->
#      e.preventDefault()
#      psst.hide()
#      holdPlease.show @$(_submitBtnSel)
#      formData = @form.getVals()
#      @model.save formData,
#        wait: true # Don't update the client model until the server state is changed
#
#    onSync: -> perch.hide()
#
#    onError: (model, xhr) ->
#      if xhr.status is 0
#        msg = 'Unknown Server Error'
#      else
#        msg = "#{xhr.status}: #{xhr.statusText}"
#      @_showErr msg
#
#    onInvalid: (model, msg) ->
#      @_showErr msg

    onClickNext: ->
      @curPage++
      @form?.remove()
      # Check to see if it's the last page
      if @curPage is _fields.length
        @_getData()._sendData()._showComplete @curPage
      else
        @_getData()._showFields @curPage

    onGameClicked: ->
#      console.log 'game clicked'
      perch.hide() # Otherwise perch flips out becuase you're showing two in a row. Silly bootstrap.


  ProfileDialog





