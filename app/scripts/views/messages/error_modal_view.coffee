define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./error_modal_view.hbs", 
  'bootstrap'], ($, Backbone, Handlebars, tempfile) ->
  ErrorModalView = Backbone.View.extend
    initialize: (options) ->
      @message = options.message
      @title = options.title

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template({title: @title, message: @message}))
      @

    display: ->
      #$("#StagingRegion").html @render().el
      $("#errorModal").modal()
      
  ErrorModalView