define [
  'jquery',
  'backbone',
  'Handlebars',
  "text!./results_progress_bar_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ResultsProgressBarView = Backbone.View.extend
    initialize: (options) ->

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template())
      this

  ResultsProgressBarView
