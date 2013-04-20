define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars',
  "text!./profile_dialog.hbs"], ($, _, Backbone, Handlebars, tempfile) ->
  ProfileDialog = Backbone.View.extend  

    getTemplateData: (data) ->
      user = 
        name: data.get('name')
        email: data.get('email')

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template( { user: @getTemplateData(@model) } ))
      this

  ProfileDialog
