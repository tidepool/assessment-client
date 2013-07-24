
define [
  'underscore'
  'classes/model'
  'Handlebars'
  './chart_colors'
], (
  _
  Model
  Handlebars
  chartColors
) ->


  # ----------------------------------------------------------------------------- Model

  Export = Model.extend
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

    parse: (resp, options) ->
      resp = @dewrap resp
      resp.chartValues = @_prepareData resp.chartValues
      resp


  Export




