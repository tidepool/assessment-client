define [
  'Backbone'], (Backbone) ->  
  User = Backbone.Model.extend
    urlRoot: ->
      "#{window.apiServerUrl}/api/v1/users"

    initialize:  ->
      # @url = "#{window.apiServerUrl}/api/v1/me"

    isGuest: ->
      @get('guest')
      
  User
    