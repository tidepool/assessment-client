
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
    className: 'chart doughnut'
    initialize: ->
      throw new Error 'Need options.data' unless @options.data
      @model = new ChartModel @options.data, { parse:true }

    render: ->
      @$el.html @tmpl @model.attributes
      @_renderChart @model.attributes.chartValues
      @


  # ---------------------------------------------------------------------------- Private
    _renderChart: (chartData) ->
      $canvas = @$(_canvasSel)
      return unless $canvas

      options = _.extend @model.attributes.options, {
        percentageInnerCutout: 33
      }
      ctx = $canvas[0].getContext("2d")
      barChart = new Chart(ctx).Doughnut(chartData, options)



  View


