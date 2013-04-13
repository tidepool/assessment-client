define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./scores_summary_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ScoresSummaryView = Backbone.View.extend
    events:
      "click #go_dashboard": "goDashboard"

    initialize: (options) ->
      @scores = @model.get('scores')
      
    render: ->
      template = Handlebars.compile(tempfile)
      data = (score for score_name, score of @scores)
      $(@el).html(template(results: data))
      this

    goDashboard: ->
      Backbone.history.navigate('/dashboard', {trigger: true})
      
  ScoresSummaryView