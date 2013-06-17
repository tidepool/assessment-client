
define [
  'underscore'
  'backbone'
  'Handlebars'
  './chart_colors'
], (
  _
  Backbone
  Handlebars
  chartColors
) ->


  # ----------------------------------------------------------------------------- Model

  Model = Backbone.Model.extend
    defaults:
      name: 'Default Chart Name'
      width: 150
      height: 150
      chartValues: []
      colors: _.clone chartColors
      options: {}

    _prepareData: (data) ->
      preppedData = []
      i = 0
      for label, value of data
        preppedData.push
          label: label
          color: chartColors[i]
          value: value
        i++
      preppedData

    parse: (resp) ->
      resp.chartValues = @_prepareData resp.chartValues
      resp


  Model




