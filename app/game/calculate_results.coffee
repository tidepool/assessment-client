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
      @_getGameResults()

    render: ->
      @$el.html tmpl
      @


    # ------------------------------------------------------------- Helper Methods
    _getGameResults: ->
      promise = @model.getResult()
      promise.done @_gotGameResults
      promise.fail @_errGameResults

    _showResults: ->
      if app.user.isGuest()
        app.router.navigate 'guestSignup',
          trigger: true
      else
        app.router.navigate 'dashboard',
          trigger: true


    # ------------------------------------------------------------- Callbacks
    _gotGameResults: (msg) ->
      # TODO: remove the setTimeout, it's only to make it feel right for testing
      setTimeout @_showResults, 1500

    _errGameResults: (msg) ->
      console.log "#{_me}._errGameResults()"
      #TODO: log analytics error/notify Tidepool. An error calculating analytics results is catastrophic and means a user wasted 10 minutes or so.
      #TODO: try again a few times before going asplodey
      perch.show
        title: 'Doh. Pretty Srs Error.'
        msg: msg
        btn1Text: 'Ok'
        onClose: -> app.router.navigate('home', trigger: true)
        mustUseButton: true


  Me

