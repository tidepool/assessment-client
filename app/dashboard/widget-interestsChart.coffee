
define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./widget-chart.hbs'
  'charts/doughnut'
  'composite_views/perch'
], (
  _
  Backbone
  Handlebars
  tmpl
  DoughnutChart
  perch
) ->

  _canvasSel = 'canvas'
  _widgetSel = '.widget'
  _chartName = 'Interests'

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: 'holder'
    tagName: 'section'
    events:
      click: 'onClick'

    render: ->
      @$el.html @tmpl name: _chartName
      @chart = new DoughnutChart
        data:
          name: _chartName
          chartValues: @model.attributes
          options: animation: false
      @$(_widgetSel).append @chart.render().el
      @


    onClick: ->
      perch.show
        title: _chartName
        large: true
        content: new DoughnutChart
          data:
            name: _chartName
            chartValues: @model.attributes
            width: 450
            height: 300



  View


