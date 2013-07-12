
define [
  'backbone'
  'Handlebars'
  'dashboard/widgets/base'
  'game/results/emotions'
  'text!./highest_emotion.hbs'
], (
  Backbone
  Handlebars
  Widget
  EmotionsResultView
  tmpl
) ->

  _widgetSel = '.widget'

  View = Widget.extend
    className: 'doubleWide tall highestEmotion'

    render: ->
      @$el.html tmpl
      latestResult = @collection.at @collection.length - 1
      view = new EmotionsResultView model:latestResult
      @$(_widgetSel).append view.render().el
      @

  View.dependsOn = 'entities/results/results'
  View.fetchOptions = data: type: 'EmoResult'
  View


