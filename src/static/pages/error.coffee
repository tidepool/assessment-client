define [
  'backbone'
  'Handlebars'
  'text!./error.hbs'
], (
  Backbone
  Handlebars
  tmpl
) ->

  _tmpl = Handlebars.compile tmpl

  Me = Backbone.View.extend
    title: 'Error'
    className: 'errorPage'
    initialize: ->
      @error = @options.params
      @error.objectString = JSON.stringify @error.object
      console.warn error:@error
    render: ->
      @$el.html _tmpl @error
      @

  Me

