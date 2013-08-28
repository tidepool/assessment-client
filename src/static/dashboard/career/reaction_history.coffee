define [
  'backbone'
  'Handlebars'
  'text!./reaction_history.hbs'
  'dashboard/widgets/base'
  'game/results/reaction_time_history'
], (
  Backbone
  Handlebars
  tmpl
  Widget
  HistoryView
) ->

  _widgetSel = '.widget'

  View = Widget.extend
    className: 'coolTones doubleWide reaction-history'

    render: ->
      @$el.html tmpl
      historyView = new HistoryView collection:@collection
      @$(_widgetSel).append historyView.render().el
      historyView.renderChart()
      return this


  View.dependsOn = 'entities/results/results'
  View.fetchOptions = data: type: 'ReactionTimeResult'
  View


