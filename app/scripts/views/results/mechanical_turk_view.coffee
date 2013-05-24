define [
  'jquery',
  'backbone',
  'Handlebars',
  "text!./mechanical_turk_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  MechanicalTurkView = Backbone.View.extend
    initialize: (options) ->
      @assessment = options.assessment

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template(assessment_id: @assessment.get('id')))
      this
      
  MechanicalTurkView