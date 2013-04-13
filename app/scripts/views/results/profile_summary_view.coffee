define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./profile_summary_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ProfileSummaryView = Backbone.View.extend
    events:
      "click #go_dashboard": "goDashboard"

    initialize: (options) ->
      @profileDescription = @model.get('profile_description')

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template(result: @profileDescription))
      this

    goDashboard: ->
      Backbone.history.navigate('/dashboard', {trigger: true})
      
  ProfileSummaryView