define [
  'jquery'
  'underscore'
  'backbone'
  'Handlebars'
  'core'
  'text!./friend_survey.hbs'
  'text!./friend_survey-thanks.hbs'
  './friend_survey-fields'
  'ui_widgets/icon_slider'
  'ui_widgets/hold_please'
], (
  $
  _
  Backbone
  Handlebars
  app
  tmpl
  tmplThanks
  fieldData
  IconSlider
  holdPlease
) ->

  _contentSel = '#ContentHolder'
  _submitSel = '#SubmitForm'

  Fields = Backbone.Collection.extend
    url: -> "#{app.cfg.apiServer}/api/v1/games/#{@game_id}/friend_survey"
    toJSON: (options) ->
      nvp = {}
      @each (model) -> nvp[model.attributes.question_id] = model.attributes.value
      nvp
    sync: -> $.post _.result(@, 'url'), @toJSON()


  Me = Backbone.View.extend
    title: 'Help a Friend'
    className: 'friendSurveyPage'
    events: 'click #SubmitForm': 'onSubmit'
    initialize: ->
      _.bindAll @, 'onSync', 'onError'
      @collection = new Fields fieldData
      @collection.game_id = @options.params.game_id
      # TODO: Get both the game and the user

    render: ->
#      if app.user.isLoggedIn()
#        app.analytics.trackKeyMetric 'Friend Survey', 'User Viewed Survey Page'
#      else
#        app.analytics.trackKeyMetric 'Friend Survey', 'Anonymous Viewed Survey Page'
      @$el.html tmpl
      @collection.each (model) =>
        question = new IconSlider model:model
        @$(_contentSel).append question.render().el
      @

    onSubmit: ->
#      console.log
#        coll:@collection.toJSON()
#        collObj:@collection
      holdPlease.show _submitSel
      app.analytics.trackKeyMetric 'Friend Survey', 'Submitted Answers'
      promise = @collection.sync()
      promise.done @onSync
      promise.fail @onError
    onSync: ->
      holdPlease.hide()
      @$el.html tmplThanks
    onError: ->
      holdPlease.hide()
      throw new Error 'Problem saving'


  Me

