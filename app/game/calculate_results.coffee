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

  Me = Backbone.View.extend
    className: 'calculateResults'

    initialize: ->
      _.bindAll @, '_gotGameResults', '_errGameResults'
      #@listenTo @model, 'change', @onChange
      @listenTo @model, 'all', (e,model) -> console.log( e:e, model:model )
      #@_getGameResults()
      app.analytics.track @className, 'Get game results'

    render: ->
      @$el.html tmpl
      @


    # ------------------------------------------------------------- Helper Methods
    _showResults: ->
      if app.user.isGuest()
        app.router.navigate 'guestSignup',
          trigger: true
      else
        app.router.navigate 'dashboard',
          trigger: true


    # ------------------------------------------------------------- Callbacks
    _gotGameResults: (msg) ->
      console.log "#{_me}._gotGameResults()"
      console.log
        model: @model
        msg: msg
      app.analytics.track @className, 'Successfully got game results'
      @_showResults

    _errGameResults: (msg) ->
      app.analytics.track @className, 'Error Getting game results'
      #TODO: try again a few times before going asplodey
      perch.show
        title: 'Doh. Pretty Srs Error.'
        msg: msg
        btn1Text: 'Ok'
        onClose: -> app.router.navigate('home', trigger: true)
        mustUseButton: true

    onChange: (model) ->
      console.log "#{_me}.model.result changed"
      console.log
        model: model.attributes

  Me

