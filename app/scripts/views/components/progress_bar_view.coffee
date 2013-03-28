define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./progress_bar_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ProgressBarView = Backbone.View.extend

    initialize: (options) ->
      @numOfStages = options.numOfStages
      @progressBarStages = []
      width = 100 / @numOfStages
      for i in [0...@numOfStages]
        firstOrLast = ""
        firstOrLast = "first" if i is 0 
        firstOrLast = "last" if i is @numOfStages - 1
        @progressBarStages << { firstOrLast: firstOrLast, index: i, width: width }


    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template({progressBarStages: @progressBarStages}))
      this

    setStageCompleted: (stage) ->
      for i in [0..@numOfStages]
        if i <= stage
          $("#progress_stage#{i}").addClass("complete")
        else
          $("#progress_stage#{i}").removeClass("complete")
  ProgressBarView
