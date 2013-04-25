define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars', 
  'nested_view',
  'text!./dashboard_main_view.hbs',
  'dashboard/detailed_results_view',
  'dashboard/charts_view'], ($, _, Backbone, Handlebars, NestedView, tempfile, DetailedResultsView, ChartsView) ->
  DashboardMainView = NestedView.extend  
    name: 'dashboard_main_view'

    postInitialize:  ->
      result = @options.assessment.result
      @profile = result.get('profile_description')
      # For debugging now:
      if !@profile?
        @profile = 
          logo_url: "The Stickler.png"
          name: "The Stickler"
          one_line: "Cras mattis consectetur purus sit amet fermentum."
          description: [
            "Aenean lacinia bibendum nulla sed consectetur.",
            "Curabitur blandit tempus porttitor. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."
          ]
          bullet_description: [
            "Cras mattis consectetur purus sit amet fermentum.",
            "Vestibulum id ligula porta felis euismod semper."
          ]
      @scores = result.get('scores')
      @assessment = @options.assessment

    getTemplate: ->
      template = Handlebars.compile(tempfile)

    getTemplateData: ->
      data = 
        profile: @profile,
        scores: @scores
      
  DashboardMainView
