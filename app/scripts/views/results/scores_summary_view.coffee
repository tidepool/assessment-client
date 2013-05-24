define [
  'jquery',
  'backbone',
  'Handlebars',
  "text!./scores_summary_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ScoresSummaryView = Backbone.View.extend
    events:
      "click #go_dashboard": "goDashboard"

    initialize: (options) ->
      @result = options.assessment.get('result')
      
    render: ->
      template = Handlebars.compile(tempfile)
      
      if @result?
        scores = @result.get('scores')
        data = (score for score_name, score of scores)

      $(@el).html(template(results: data))
      this

    goDashboard: ->
      Backbone.history.fragment = ""
      Backbone.history.navigate('dashboard', {trigger: true})
      
  ScoresSummaryView