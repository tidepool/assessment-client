define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars', 
  'vendor/nested_view',
  'text!./detailed_results_view.hbs'], ($, _, Backbone, Handlebars, NestedView, tempfile) ->
  DetailedResultsView = NestedView.extend
    name: 'detailed_results_view'

    postInitialize: ->

    getTemplate: ->
      template = Handlebars.compile(tempfile)

    getTemplateData: ->
      context = @options

      result = 
        name: context.name
        logo_url: context.logo_url
        one_liner: context.one_liner    

  DetailedResultsView