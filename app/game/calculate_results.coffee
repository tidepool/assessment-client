define [
  'backbone'
  'Handlebars'
  'text!./calculate_results.hbs'
  'core'
  'composite_views/perch'
], (
  Backbone
  Handlebars
  tmpl
  app
  perch
) ->

  _me = 'game/calculate_results'
  _statusMsgSel = '#StatusMessage'

  View = Backbone.View.extend
    className: 'calculateResults'
    initialize: ->
#      @listenTo @model, 'all', (e,model) -> console.log( e:e, model:model )
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
      if app.user.isGuest()
        app.router.navigate 'guestSignup',
          trigger: true
      else
        app.router.navigate 'dashboard',
          trigger: true


    # ------------------------------------------------------------- Callbacks
    _gotGameResults: ->
      #console.log "#{_me}._gotGameResults()"
      #console.log model: @model
      app.analytics.track @className, 'Successfully calculated game results'
      @_showResults()

    onError: (model, msg) ->
      app.analytics.track @className, 'Error Getting game results'
      #TODO: try again a few times before going asplodey
      perch.show
        title: 'Doh. Pretty Srs Error.'
        msg: msg
        btn1Text: 'Ok'
        onClose: -> app.router.navigate('home', trigger: true)
        mustUseButton: true

    onChange: (model) ->
      #console.log "#{_me}.model.result changed"
      #console.log model: model.attributes
      @_updateStatusMsg model
      @_gotGameResults() if model.attributes.status.state is model.STATES.done



  View

