
define [
  'backbone'
  'Handlebars'
  './chart'
  'text!./chart_with_swatches.hbs'
  'chart'
], (
  Backbone
  Handlebars
  ChartModel
  tmpl
  ChartLib
) ->

  _canvasSel = 'canvas'

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: 'chart polarArea'
    initialize: -> @model = new ChartModel @options.data, { parse:true }

    render: ->
      @$el.html @tmpl @model.attributes
      @_renderChart @model.attributes.chartValues
      @


    # ---------------------------------------------------------------------------- Private
    _renderChart: (chartData) ->
      $canvas = @$(_canvasSel)
      return unless $canvas

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



  View


