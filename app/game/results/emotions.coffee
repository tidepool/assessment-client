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

  View = ResultView.extend
    className: 'emotions'
    tmpl: Handlebars.compile tmpl
    start: ->
      score = @model.get 'score'
      score.display_emotion_title = markdown.toHTML score.display_emotion_title
      score.display_emotion_description = markdown.toHTML score.display_emotion_description
      @model.set 'score', score
      @

  View

