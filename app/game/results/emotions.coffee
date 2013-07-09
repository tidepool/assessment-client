define [
  'backbone'
  'Handlebars'
  'game/results/base'
  'text!./emotions.hbs'
  'markdown'
], (
  Backbone
  Handlebars
  ResultView
  tmpl
  markdown
) ->

  _emoticonSel = '.emoticon'
  _renderDelay = 200

  View = ResultView.extend
    className: 'emotions'
    tmpl: Handlebars.compile tmpl
    start: ->
      score = @model.get 'score'
      score.display_emotion_title = markdown.toHTML score.display_emotion_title if score.display_emotion_title
      score.display_emotion_description = markdown.toHTML score.display_emotion_description if score.display_emotion_description
      @model.set 'score', score
      @

    render: ->
      @$el.html @tmpl @model.attributes
      setTimeout (=> @$(_emoticonSel).addClass @model.attributes.score.display_emotion_name), _renderDelay
      return this

  View

