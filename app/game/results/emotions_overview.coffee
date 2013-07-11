define [
  'backbone'
  'game/results/base'
], (
  Backbone
  ResultView
) ->

  _emoticonSel = '.emoticon'
  _renderDelay = 200

  View = ResultView.extend
    className: 'emotionsOverview'

    # TODO: Show a chart that gives an emo overview


  View

