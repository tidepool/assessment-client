
define [
  'backbone'
  'Handlebars'
  'dashboard/widgets/base'
  'game/results/emotions_history'
], (
  Backbone
  Handlebars
  Widget
  HistoryView
) ->

  _widgetSel = '.widget'

  View = Widget.extend
    className: 'doubleWide historicalHighestEmotion'

    render: ->
      @$el.html @tmplBase
        title: 'Your Emotional Timeline'
      view = new HistoryView collection:@collection
      @$(_widgetSel).append view.render().el
      view.renderChart()
      @

  View.dependsOn = 'entities/results/results'
  View.fetchOptions = data: type: 'EmoResult'
  View
