define [
  'jquery',
  'Backbone',
  "hbs!./start_view"], ($, Backbone, template) ->
  StartView = Backbone.View.extend
    events:
      'submit #new_assessment': 'startAssessment'

    initialize: (options) ->
      @eventDispatcher = options.eventDispatcher

    render: ->
      $(@el).html(template(definition: @model.get('definition')))
      $(".login_logout").css("visibility", "visible")
      this
      
    startAssessment: (event) ->
      @eventDispatcher.trigger("startAssessment")
      event.preventDefault()

  StartView