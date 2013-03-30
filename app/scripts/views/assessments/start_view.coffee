define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./start_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  StartView = Backbone.View.extend
    events:
      'click #startAssessment': 'startAssessment'

    initialize: (options) ->


    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template({definition: @model.get('definition')}))
      $(".login_logout").css("visibility", "visible")
      this
      
    startAssessment: (event) ->
      #TODO: Change this to 0 or -1 by making the initial stage -2.
      @model.updateProgress(0)

  StartView