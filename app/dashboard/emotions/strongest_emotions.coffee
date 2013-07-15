
define [
  'backbone'
  'dashboard/widgets/base'
  'game/results/emotions_overview'
], (
  Backbone
  Widget
  EmotionsOverviewResult
) ->

  _widgetSel = '.widget'
  _chartName = 'Emotions'

  View = Widget.extend
    events: 'click .widget': 'onClick'

    render: ->
      @$el.html @tmplBase
        title: _chartName
        className: 'pressable'
      @emotionsOverviewResult = new EmotionsOverviewResult collection:@collection
      @$(_widgetSel).append @emotionsOverviewResult.el
      @emotionsOverviewResult.renderChart() # Has to be done afer it's in the dom because it's canvas
      @

    onClick: ->
      @emotionsOverviewResult.$el.trigger 'click'

    close: ->
      @emotionsOverviewResult?.remove()
      @remove()


  View.dependsOn = 'entities/results/results'
  View.fetchOptions = data: type: 'EmoResult'
  View


