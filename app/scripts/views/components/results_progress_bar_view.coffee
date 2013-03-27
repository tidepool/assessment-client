define [
  'jquery',
  'Backbone',
  "hbs!./results_progress_bar_view"], ($, Backbone, template) ->
  ResultsProgressBarView = Backbone.View.extend
    initialize: (options) ->

    render: ->
      $(@el).html(template())
      this

  ResultsProgressBarView
