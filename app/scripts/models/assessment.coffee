define [
  'Backbone'], (Backbone) ->  
  Assessment = Backbone.Model.extend
    urlRoot: '/api/v1/assessments'

    initialize:  ->
      @url = window.apiServerUrl + @urlRoot

    updateProgress: (stageCompleted) ->
      # Rails 4 is going to introduce support for the PATCH verb in HTTP
      # TODO: Switch to PATCH when Rails 4 switch happens
      attrs = { 'stage_completed': stageCompleted }
      @save attrs,
        patch: false
        url: @url + "/#{@get('id')}"
        success: (model, response, options) =>

        error: (model, xhr, options) =>
          # TODO: Error Handling
          alert("stageCompleted error")
 
  Assessment