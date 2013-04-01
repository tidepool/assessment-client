define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./results_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ResultsView = Backbone.View.extend
    events:
      "click #go_dashboard": "goDashboard"

    initialize: (options) ->
      @noResults = options.noResults

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template(results: @model, noResults: @noResults))
      $(".login_logout").css("visibility", "visible")
      this

    getResults: ->
      @session.user

    goDashboard: ->
      window.location.href = "/dash"
      
  ResultsView