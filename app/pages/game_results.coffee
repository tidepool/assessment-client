define [
  'backbone'
  'Handlebars'
  'text!./game_results.hbs'
  'entities/results/game'
  'entities/results/results'
  'game/results/reaction_time_history'
  'ui_widgets/psst'
  'core'
  'ui_widgets/guest_signup'
], (
  Backbone
  Handlebars
  tmpl
  GameResults
  Results
  ReactionTimeHistoryView
  psst
  app
  GuestSignup
) ->

  _contentSel = '#ResultsDisplay'
  _ctaSel = '#CallToAction'
  _rtType = 'ReactionTimeResult'

  Me = Backbone.View.extend
    title: 'Results'
    className: 'gameResultsPage'

    initialize: ->
      throw new Error "Need game_id" unless @options.params?.game_id?
      @collection = new GameResults
        game_id: @options.params.game_id
      @listenTo @collection, 'sync', @onSync
      @listenTo @collection, 'error', @onError
      @collection.fetch()

    render: ->
      @$el.html tmpl
      # If they're a guest, show the guest conversion widget
      if app.user.isGuest()
        guestSignup = new GuestSignup()
        @$(_ctaSel).html guestSignup.render().el
      return this

    _renderResults: ->
      @$(_contentSel).empty()
      @collection.each (model) ->
        @$(_contentSel).append model.view?.render().el
      @_appendReactionTimeHistory() if @collection.find (result) -> result.attributes.type is _rtType
      return this

    _appendReactionTimeHistory: ->
      rtResults = new Results()
      history = new ReactionTimeHistoryView
        collection: rtResults
      history.collection.fetch data: type:_rtType
      @$(_contentSel).append history.render().el

    onSync: (collection, data) ->
      if data?.status?.state is Results.STATES.pending
        @$(_contentSel).empty()
        psst
          sel: _contentSel
          title: "Results Not Calculated"
          msg: "Sorry, but for some reason results haven't been calculated for game #{collection.game_id}"
          type: psst.TYPES.error
      else if collection.length
        @_renderResults()
      else
        @$(_contentSel).empty()
        psst
          sel: _contentSel
          title: "No Results Found"
          msg: "Sorry, but we didn't find any results for game #{collection.game_id}"
          type: psst.TYPES.error

    onError: (collection, xhr) ->
      @$(_contentSel).empty()
      psst
        sel: _contentSel
        title: "Error Getting Results"
        msg: "Sorry, but we coudln't get any results for game #{collection.game_id}"
        type: psst.TYPES.error


  Me


