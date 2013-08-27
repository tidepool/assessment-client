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

    render: ->
      score = _.clone @model.attributes.score # avoid modifying the original object
      score.display_emotion_title = markdown.toHTML score.display_emotion_title if score.display_emotion_title
      score.display_emotion_description = markdown.toHTML score.display_emotion_description if score.display_emotion_description
      attrs = @model.toJSON()
      attrs.score = score
      @$el.html @tmpl attrs
      setTimeout (=> @$(_emoticonSel).addClass @model.attributes.score.display_emotion_name), _renderDelay
      return this

  View

