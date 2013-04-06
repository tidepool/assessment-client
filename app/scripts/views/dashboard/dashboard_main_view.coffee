define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars', 
  'nested_view',
  'text!./dashboard_main_view.hbs',
  'dashboard/detailed_results_view'], ($, _, Backbone, Handlebars, NestedView, tempfile, DetailedResultsView) ->
  DashboardMainView = NestedView.extend  
    name: 'dashboard_main_view'

    postInitialize: ->
      @result = @model

    getTemplate: ->
      template = Handlebars.compile(tempfile)

    getTemplateData: ->
      result = 
        result: {
          name: @result.get('name')
          logo_url: @result.get('logo_url')
          one_liner: @result.get('one_liner')
        }

  DashboardMainView