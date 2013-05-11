define [
  'jquery'
  'Backbone'
  'Handlebars'
  "text!./home_page_view.hbs"
], (
  $
  Backbone
  Handlebars
  tmpl
) ->
  StartView = Backbone.View.extend
    initialize: () ->
      @template = Handlebars.compile(tmpl)
    render: ->
      @$el.html @template()
      @

  StartView