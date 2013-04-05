define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars', 
  'vendor/nested_view',
  'text!./detailed_results_view.hbs'], ($, _, Backbone, Handlebars, tempfile) ->
DetailedResultsView = NestedView.extend
  getTemplate: ->
    template = Handlebars.compile(tempfile)

  getTemplateData: ->
    

DetailedResultsView