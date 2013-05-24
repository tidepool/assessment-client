define [
  'jquery',
  'underscore',
  'backbone',
  'Handlebars', 
  'nested_view',
  'chart',
  'text!./charts_view.hbs'], ($, _, Backbone, Handlebars, NestedView, Chart, tempfile) ->
  ChartsView = NestedView.extend
    name: 'charts_view'

    postInitialize: ->

    getTemplate: ->
      template = Handlebars.compile(tempfile)

    getTemplateData: ->
      @scores = @options

    postRender: ->
      for scoreName, scoreValue of @scores   
        @renderGraph(scoreName, scoreValue)

    renderGraph: (scoreName, scoreValue) ->
      chartCanvasName = "##{scoreName}Chart"
      $canvas = this.$el.find(chartCanvasName)
      return if not $canvas? || $canvas.length == 0

      context = $canvas[0].getContext("2d")
      labels = (label for label, value of scoreValue.score)
      data = (value for label, value of scoreValue.score)

      colors = ["#D97041", "#C7604C", "#21323D", "#9D9B7F", "#7D4F6D", "#584A5E"]

      i = 0
      chartData = []
      for label, value of scoreValue.score
        chartData[i] = 
          color: colors[i]
          value: value
        i += 1
      # chartData = {
      #   labels: labels,
      #   datasets: [
      #     {
      #       fillColor : "rgba(151, 187, 205, 0.5)",
      #       strokeColor : "rgba(151, 187, 205, 1)",
      #       data: data
      #     }
      #   ]
      # }
      # options = { scaleStartValue: 0 }
      options = {}
      barChart = new Chart(context).PolarArea(chartData, options)

  ChartsView