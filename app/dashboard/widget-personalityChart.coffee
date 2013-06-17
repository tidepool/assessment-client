
define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./widget-chart.hbs'
  './chartColors'
  'chart'
], (
  _
  Backbone
  Handlebars
  tmpl
  chartColors
  Chart
) ->

  _canvasSel = 'canvas'
  _widgetSel = '.widget'
  _chartName = 'Personality'

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: 'holder personalityChart'
    tagName: 'section'
    initialize: ->

    render: ->
      data = @_prepareData()
      @$el.html @tmpl data
      $canvas = @$(_canvasSel)
      @_renderChartOnCanvas $canvas, data.chartValues
      @


    # ---------------------------------------------------------------------------- Private
    _prepareData: ->
      data = {}
      chartValues = []
      colors = _.clone chartColors
      for label, value of @model.attributes
        chartValues.push
          label: label
          color: colors.pop()
          value: value
      data.chartValues = chartValues
      data.name = _chartName
      data

    _renderChartOnCanvas: ($canvas, chartData) ->
      # Compute the upward bound of the chart
      max = _.max chartData, (d) -> d.value
      max = Math.ceil max.value

      options =
        scaleShowLine: false
        scaleShowLabels: false
        scaleOverride: true
        scaleSteps: max
        scaleStepWidth: 1
        scaleStartValue: 0

      ctx = $canvas[0].getContext("2d")
      barChart = new Chart(ctx).PolarArea(chartData, options)

    _drawKey: (data) ->


  View


