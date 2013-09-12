define [
  'backbone'
  'Handlebars'
  'text!./error.hbs'
  'entities/daddy_ios'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  ios
  app
) ->

  _tmpl = Handlebars.compile tmpl

  Me = Backbone.View.extend
    title: 'Error'
    className: 'errorPage'
    initialize: ->
      @error = @options.params
      @error.objectString = JSON.stringify @error.object
      console.warn error:@error
      ios.error @error.message
      app.analytics.track @className, @error.message
    render: ->
      @$el.html _tmpl @error
      @

  Me

