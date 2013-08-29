
define [
  'backbone'
  'dashboard/widgets/base'
  'composite_views/perch'
  'charts/polar_area'
], (
  Backbone
  Widget
  perch
  PolarAreaChart
) ->

  _widgetSel = '.widget'
  _chartName = 'Personality'

  View = Widget.extend
    events:
      'click .widget': 'onClick'
    className: 'chart-big5'

    render: ->
      @$el.html @tmplBase
        title: _chartName
        className: 'pressable'
      @chart = new PolarAreaChart
        data:
          name: _chartName
          chartValues: @model.attributes.big5_score
          options: animation: false
      @$(_widgetSel).append @chart.render().el
      @

    onClick: ->
      perch.show
        title: _chartName
        large: true
        btn1Text: null
        content: new PolarAreaChart
          data:
            name: _chartName
            chartValues: @model.attributes.big5_score
            width: 450
            height: 300


  View.dependsOn = 'entities/my/personality'
  View


