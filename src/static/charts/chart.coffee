
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
      tuples = _.map data, (val, key) -> [key, val]
      tuples = _.sortBy tuples, (t) -> t[0]
      for value in tuples
        preppedData.push
          label: value[0]
          color: chartColors[i]
          value: value[1]
        i++
      preppedData

    parse: (resp, options) ->
      resp = @dewrap resp
      resp.chartValues = @_prepareData resp.chartValues
      resp


  Export




