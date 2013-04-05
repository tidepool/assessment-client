define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars', 
  'vendor/nested_view',
  'text!./dash_main_view.hbs'], ($, _, Backbone, Handlebars, tempfile) ->
DashboardMainView = NestedView.extend
  
  postInitialize: ->

  getTemplate: ->
    template = Handlebars.compile(tempfile)

  getTemplateData: ->
    @model.get('')

DashboardMainView