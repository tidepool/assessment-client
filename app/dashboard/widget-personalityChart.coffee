
define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./widget-chart.hbs'
  'composite_views/perch'
  'charts/polar_area'
], (
  _
  Backbone
  Handlebars
  tmpl
  perch
  PolarAreaChart
) ->

  _canvasSel = 'canvas'
  _widgetSel = '.widget'
  _chartName = 'Personality'

  View = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    className: 'holder'
    tagName: 'section'
    events:
      click: 'onClick'

    render: ->
      @$el.html @tmpl name: _chartName
      @chart = new PolarAreaChart
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
        content: new PolarAreaChart
          data:
            name: _chartName
            chartValues: @model.attributes
            width: 450
            height: 300




  View


