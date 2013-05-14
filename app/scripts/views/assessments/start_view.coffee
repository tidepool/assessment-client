define [
  'jquery'
  'Backbone'
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
    events:
      'click #startAssessment': 'startAssessment'

    initialize: (options) ->
      @tmpl = Handlebars.compile tmpl

    render: ->
      debugger
      @$el.html @tmpl
        definition: @model.get('definition')

      $(".login_logout").css("visibility", "visible")
      this
      
    startAssessment: (event) ->
      #TODO: Change this to 0 or -1 by making the initial stage -2.
      @model.updateProgress(0)

  StartView