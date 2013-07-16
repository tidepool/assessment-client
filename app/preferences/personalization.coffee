

define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'entities/preferences/training-descriptions'
  'entities/preferences/training'
  'text!./personalization.hbs'
  'text!./personalization-games.hbs'
  'ui_widgets/formation'
  'ui_widgets/hold_please'
  'ui_widgets/psst'
  'composite_views/perch'
],
(
  $
  _
  Backbone
  Handlebars
  TrainingPreferencesDesc
  TrainingPreferences
  tmpl
  tmplGames
  Formation
  holdPlease
  psst
  perch
) ->

  _btnSel = '.actionZone .btn'
#  _errorHolderSel = '.formation .buttonArea'
  _contentSel = '.content'
  _stepsSel = '.stepsRemainingWizard li'
  _completedClass = 'complete'
  _tmpl = Handlebars.compile tmpl
  _pageCount = 2
  _titles = [ '1. Productivity', '2. Mood' ]
  _categories = [ 'productivity', 'mood' ]
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
      @data = new TrainingPreferences()
      @fields = new TrainingPreferencesDesc()
      # Get content from server
      promise = $.when @data.fetch(), @fields.fetch() # We need two different server responses to proceed
      promise.done _.bind @onSync, @
      promise.fail @onError
      @curPage = 0

    render: ->
      holdPlease.show @$el
      @

    renderContents: ->
#      console.log
#        data: @data
#        fields: @fields
      holdPlease.hide @$el
      @$el.html _tmpl
      @_showFields(@curPage)


    # ----------------------------------------------------------- Server Event Handlers
    onSync: (dataResp, fieldsResp) ->
#      console.log
#        dataRespData: dataResp[0]
#        fieldsRespData: fieldsResp[0]
      @fields.setValues dataResp[0].data if dataResp and dataResp[0]
      @renderContents()

    onError: (model, xhr) ->
      if xhr.status is 0
        msg = 'Unknown Server Error'
      else
        msg = "#{xhr.status}: #{xhr.statusText}"
      perch.hide()


    # ----------------------------------------------------------- View-Oriented Helpers
    _showFields: (idx) ->
      @options.app.analytics.track 'Personalizations', "Showing Step: #{idx}"
      @_indexActions idx
      # Form Explanation
      @$(_explanationSel).html _explanationTmpl
        title: _titles[idx]
        subtitle: 'Select all options that you are interested to improve.'
      # Form Fields
      @form = new Formation data: @fields.where( category: _categories[idx] )
      @$(_contentSel).html @form.render().el
      @

    _indexActions: (idx) ->
      @$(_stepsSel).eq(idx).addClass _completedClass
      @$(_infoSel).html _infoTmpl { text: _infoTips[idx] }

    _showComplete: (idx) ->
      @options.app.analytics.track 'Personalizations', "Completed"
      @_indexActions idx
      @$(_explanationSel).html _explanationTmpl
        title: 'Your Personalized Program is ready!'
        subtitle: 'You can go back at any time and change your preferences.'
      @$(_contentSel).html tmplGames
      @$(_btnSel).remove()
      @


    # ------------------------------------------------------------ Event Handlers
    onClickNext: ->
      @curPage++
      @fields.setValues @form.getVals()
      @data.setValues @form.getVals()
      @form?.remove()
      # Check to see if it's the last page
      if @curPage is _pageCount
        @data.save()
        @_showComplete @curPage
      else
        @_showFields @curPage

    onGameClicked: ->
#      console.log 'game clicked'
      perch.hide() # Otherwise perch flips out becuase you're showing two in a row. Silly bootstrap.


  ProfileDialog





