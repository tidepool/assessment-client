define [
  'Backbone'
  'Handlebars'
], (
  Backbone
  Handlebars
) ->

  _me = 'pages/gameResult'

  Me = Backbone.View.extend
    className: 'gameResultPage'
    initialize: ->
      console.log "#{_me}.showResult()"
      @showGame() unless @app.session.assessment
      controller = new SummaryResultsController()
      controller.initialize({session: @app.session})
      controller.render()
    render: ->
      @$el.html @tmpl()
      @
  Me

