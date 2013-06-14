
define [
  'backbone'
  'Handlebars'
  'text!./widget-interestsChart.hbs'
  'text!./chartColors.json'
  'chart'
], (
  Backbone
  Handlebars
  tmpl
  chartColors
  Chart
) ->

  _canvasSel = 'canvas'
  _widgetSel = '.widget'

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: 'holder personalityChart'
    tagName: 'section'
    initialize: ->

    render: ->
      @$el.html tmpl
      $canvas = @$(_canvasSel)
      @_renderChartOnCanvas $canvas
      @


  # ---------------------------------------------------------------------------- Private
    _renderChartOnCanvas: ($canvas) ->
      return unless $canvas
      chartCanvasName = "Hello"

      scoreValue =
        score:
          'apple': 8
          'rainbow': 4
          'orange': 7
          'grape': 3
          'tomato': 10
          'unicorn': 3

      chartData = []
      colors = JSON.parse chartColors
      for label, value of scoreValue.score
        chartData.push
          color: colors.pop()
          value: value
      options =
        percentageInnerCutout: 33

      ctx = $canvas[0].getContext("2d")
      barChart = new Chart(ctx).Doughnut(chartData, options)


  View


