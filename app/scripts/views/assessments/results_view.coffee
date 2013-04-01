define [
  'jquery',
  'Backbone',
  'Handlebars',
  "text!./results_view.hbs"], ($, Backbone, Handlebars, tempfile) ->
  ResultsView = Backbone.View.extend
    events:
      "click #go_dashboard": "goDashboard"

    initialize: (options) ->
      @doNotShowResults = options.DoNotShowResults

    render: ->
      template = Handlebars.compile(tempfile)
      result = 
        name: @model.get('name')
        logo_url: @model.get('logo_url')
        one_liner: @model.get('one_liner')
      $(@el).html(template(result: result, doNotShowResults: @doNotShowResults))
      $(".login_logout").css("visibility", "visible")
      this

    goDashboard: ->
      window.location.href = "/dash"
      
  ResultsView