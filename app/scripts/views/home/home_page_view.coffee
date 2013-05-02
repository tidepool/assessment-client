define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./home_page_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  StartView = Backbone.View.extend
    events:
      'click #getStarted': 'startAssessment'

    initialize: (options) ->


    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template())
      this
      
    startAssessment: (e) ->
      #TODO: Change this to 0 or -1 by making the initial stage -2.
      e.preventDefault() 
      Backbone.history.navigate('assessment/1', {trigger: true})

  StartView