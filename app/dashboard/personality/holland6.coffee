
define [
  'backbone'
  'dashboard/widgets/base'
  'composite_views/perch'
  'charts/doughnut'
], (
  Backbone
  Widget
  perch
  DoughnutChart
) ->

  _widgetSel = '.widget'
  _chartName = 'Interests'

  View = Widget.extend
    events:
      'click .widget': 'onClick'
    className: 'chart-holland6'

    render: ->
      @$el.html @tmplBase
        title: _chartName
        className: 'pressable'
      @chart = new DoughnutChart
        data:
          name: _chartName
          chartValues: @model.attributes.holland6_score
          options: animation: false
      @$(_widgetSel).append @chart.render().el
      @

    onClick: ->
      perch.show
        title: _chartName
        large: true
        btn1Text: null
        content: new DoughnutChart
          data:
            name: _chartName
            chartValues: @model.attributes.holland6_score
            width: 450
            height: 300


  View.dependsOn = 'entities/cur_user_personality'
  View


