
define [
  'backbone'
  'dashboard/widgets/base'
  'composite_views/perch'
  'charts/pie'
], (
  Backbone
  Widget
  perch
  PieChart
) ->

  _widgetSel = '.widget'
  _chartName = 'Emotions'
  _min = .1
  _max = 5

  View = Widget.extend
    events: 'click .widget': 'onClick'

    render: ->
      @$el.html @tmplBase
        title: _chartName
        className: 'pressable'
      @chart = new PieChart
        data:
          name: _chartName
          chartValues: @_prepareData @collection
          options: animation: false
      @$(_widgetSel).append @chart.render().el
      @

    _prepareData: (collection) ->
      latestResult = @collection.at @collection.length - 1
      emotions = latestResult.attributes.calculations.final_results[0].emo_distances
      # Grab the highest 3 and the lowest 2
#      emotions = _.sortBy emotions

      # Pop them out into an array for sorting
      tuples = _.map emotions, (val, key) -> [key, val]
      tuples = _.sortBy tuples, (t) -> t[1]
      chartData = {}
      # Grab the lowest 2
      chartData[tuples[0][0]] = tuples[0][1]
      chartData[tuples[1][0]] = tuples[1][1]
      # Grab the highest 3
      chartData[tuples[tuples.length - 1][0]] = tuples[tuples.length - 1][1]
      chartData[tuples[tuples.length - 2][0]] = tuples[tuples.length - 2][1]
      chartData[tuples[tuples.length - 3][0]] = tuples[tuples.length - 3][1]
      # These are distances, so invert and normalize
      for key, value of chartData
        normalized = _max - value
        normalized = if normalized < _min then _min else normalized + _min
        chartData[key] = normalized
      console.log
        tuples: tuples
        emotions: emotions
        chartData: chartData
      chartData

    onClick: ->
      perch.show
        title: _chartName
        large: true
        btn1Text: null
        content: new PieChart
          data:
            name: _chartName
            chartValues: @_prepareData @collection
            width: 450
            height: 300


  View.dependsOn = 'entities/results/results'
  View.fetchOptions = data: type: 'EmoResult'
  View


