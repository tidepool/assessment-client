define [
  'backbone'
  'Handlebars'
  'text!./calculate_results.hbs'
  'core'
  'entities/results_calculator'
  'composite_views/perch'
  'entities/daddy_ios'
], (
  Backbone
  Handlebars
  tmpl
  app
  ResultsCalculator
  perch
  ios
) ->

  _me = 'game/calculate_results'
  _statusMsgSel = '#StatusMessage'

  View = Backbone.View.extend
    className: 'calculateResults'
    initialize: ->
#      @listenTo @model, 'all', (e,model) -> console.log( e:e, model:model )
      app.analytics.track @className, 'Saving user events...'
      @listenTo @options.eventLog, 'sync', @onEventLogSync

    render: ->
      @$el.html tmpl
      @_setStatusMsg 'Saving events.'
      @options.eventLog.save()
      @


    # ------------------------------------------------------------- Event Log
    onEventLogSync: ->
      app.analytics.track @className, 'Saved User events, starting game results calculation'
      @model = new ResultsCalculator game_id: @options.game.get 'id'
      @listenTo @model, 'change', @onChange
      @listenTo @model, 'error', @onError


    # ------------------------------------------------------------- Helper Methods
    _setStatusMsg:    (msg)   -> @$(_statusMsgSel).text msg
    _updateStatusMsg: (model) -> @_setStatusMsg model.attributes.status.message if model.attributes.status.message

    _showResults: ->
      app.router.navigate "gameResults/#{@model.attributes.game_id}", trigger: true


    # ------------------------------------------------------------- Results Polling Callbacks
    _gotGameResults: (model) ->
      #console.log model: @model
      app.analytics.track @className, 'Successfully calculated game results'
      ios.log 'Got game results'
      if ios.isUp # The ios container should be sent a message
        ios.finish()
      else
        @_showResults()

    onError: (model, xhr) ->
      msg = xhr.responseJSON?.status.message || 'Error Calculating Game Results'
      ios.error msg
      perch.show
        title: 'Sorry, There Is a Problem.'
        msg: msg
        btn1Text: 'Ok'
        onClose: => @_showResults() #-> app.router.navigate('home', trigger: true)
        mustUseButton: true

    onChange: (model) ->
      #console.log "#{_me}.model.result changed"
      #console.log model: model.attributes
      @_updateStatusMsg model
      if model.attributes.status.state is model.STATES.done
        @_gotGameResults model



  View

