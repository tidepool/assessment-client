define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./start_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  StartView = Backbone.View.extend
    events:
      'submit #new_assessment': 'startAssessment'

    initialize: (options) ->
      @eventDispatcher = options.eventDispatcher

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template({definition: @model.get('definition')}))
      $(".login_logout").css("visibility", "visible")
      this
      
    startAssessment: (event) ->
      @eventDispatcher.trigger("startAssessment")
      event.preventDefault()

  StartView