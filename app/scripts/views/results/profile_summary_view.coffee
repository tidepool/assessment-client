define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./profile_summary_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ProfileSummaryView = Backbone.View.extend
    events:
      "click #go_dashboard": "goDashboard"

    initialize: (options) ->
      @result = options.assessment.get('result')

    render: ->
      template = Handlebars.compile(tempfile)
      if @result?
        profileDescription = @result.get('profile_description')

      $(@el).html(template(result: profileDescription))
      this

    goDashboard: ->
      Backbone.history.navigate('/dashboard', {trigger: true})
      
  ProfileSummaryView