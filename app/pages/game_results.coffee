define [
  'backbone'
  'Handlebars'
  'text!./game_results.hbs'
  'entities/results/game'
  'entities/results/results'
  'game/results/reaction_time_history'
  'ui_widgets/psst'
], (
  Backbone
  Handlebars
  tmpl
  GameResults
  Results
  ReactionTimeHistoryView
  psst
) ->

  _contentSel = '#ResultsDisplay'
  _rtType = 'ReactionTimeResult'

  Me = Backbone.View.extend

    className: 'gameResultsPage'

    initialize: ->
      throw new Error "Need game_id" unless @options.params?.game_id?
      @collection = new GameResults
        game_id: @options.params.game_id
      @listenTo @collection, 'sync', @onSync
      @collection.fetch()

    render: ->
      @$el.html tmpl
      return this

    _renderResults: ->
      @collection.each (model) ->
        @$(_contentSel).append model.view?.render().el
      @_appendReactionTimeHistory() if @collection.find (result) -> result.attributes.type is _rtType
      return this

    _appendReactionTimeHistory: ->
      rtResults = new Results()
      history = new ReactionTimeHistoryView
        collection: rtResults
      history.collection.fetch data: type:_rtType
      window.coll = history.collection
      @$(_contentSel).append history.render().el

    onSync: (collection, data) ->
      if collection.length
        @_renderResults()
      else
        psst
          sel: _contentSel
          title: "No Results Found"
          msg: "Sorry, but we didn't find any results for game #{collection.game_id}"
          type: psst.TYPES.error


  Me


