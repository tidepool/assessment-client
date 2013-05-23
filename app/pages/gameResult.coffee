define [
  'Backbone'
  'Handlebars'
  'controllers/summary_results_controller'
], (
  Backbone
  Handlebars
  SummaryResultsController
) ->

  _me = 'pages/gameResult'

  Me = Backbone.View.extend
    className: 'gameResultPage'
    initialize: ->
      console.log "#{_me}.showResult()"
      #Backbone.history.navigate('game') unless @options.app.session.assessment
      @render()

    render: ->
      controller = new SummaryResultsController()
      controller.initialize({session: @options.app.session})
      @$el.html controller.render().el
      @
  Me

