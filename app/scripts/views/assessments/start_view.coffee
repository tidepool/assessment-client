define [
  'jquery'
  'backbone'
  'Handlebars'
  "text!./start_view.hbs"
],
(
  $
  Backbone
  Handlebars
  tmpl
) ->
  StartView = Backbone.View.extend
    className: 'infobox startView'
    events:
      'click #StartAssessment': 'startAssessment'

    initialize: (options) ->
      @tmpl = Handlebars.compile tmpl

    render: ->
      @$el.html @tmpl
        definition: @model.get('definition')
      @

    startAssessment: (event) ->
      @model.updateProgress(0)

  StartView