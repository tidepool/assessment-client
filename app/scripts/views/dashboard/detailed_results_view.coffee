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
      profile = @options    

  DetailedResultsView