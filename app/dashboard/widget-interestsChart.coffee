
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
  _chartName = 'Interests'

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

    _renderChartOnCanvas: ($canvas, data) ->
      options =
        percentageInnerCutout: 33
      ctx = $canvas[0].getContext("2d")
      barChart = new Chart(ctx).Doughnut(data, options)


  View


