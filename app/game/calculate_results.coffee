define [
  'backbone'
  'Handlebars'
  'text!./calculate_results.hbs'
  'core'
  'composite_views/perch'
  'entities/daddy_ios'
], (
  Backbone
  Handlebars
  tmpl
  app
  perch
  IOS
) ->

  _me = 'game/calculate_results'
  _statusMsgSel = '#StatusMessage'

  View = Backbone.View.extend
    className: 'calculateResults'
    initialize: ->
#      @listenTo @model, 'all', (e,model) -> console.log( e:e, model:model )
      @ios = new IOS
      @listenTo @model, 'change', @onChange
      @listenTo @model, 'error', @onError
      app.analytics.track @className, 'Starting game results calculation'

    render: ->
      @$el.html tmpl
      @


    # ------------------------------------------------------------- Helper Methods
    _updateStatusMsg: (model) ->
      if model.attributes.status.message
        @$(_statusMsgSel).text model.attributes.status.message

    _showResults: ->
      app.router.navigate "gameResults/#{@model.attributes.game_id}", trigger: true


    # ------------------------------------------------------------- Callbacks
    _gotGameResults: (model) ->
      #console.log model: @model
      app.analytics.track @className, 'Successfully calculated game results'
      if @ios.isUp # The ios container should be sent a message
        @ios.holla
          data: model
          status: {}
      else
        @_showResults()

    onError: (model, xhr) ->
#      console.log model:model, xhr:xhr
      # Send the user to the results page, since some of the results could be calculated, they're just suspect
      # If they're a guest send the user to play again since there's nothing else to do
      @ios.holla
        data: model
        status: xhr.responseJSON?.status
      app.analytics.track @className, 'Error Getting game results'
      perch.show
        title: 'Sorry, There Is a Problem.'
        msg: xhr.responseJSON?.status.message || xhr.statusText
        btn1Text: 'Ok'
        onClose: => @_showResults() #-> app.router.navigate('home', trigger: true)
        mustUseButton: true

    onChange: (model) ->
      #console.log "#{_me}.model.result changed"
      #console.log model: model.attributes
      @_updateStatusMsg model
      @_gotGameResults model if model.attributes.status.state is model.STATES.done



  View

