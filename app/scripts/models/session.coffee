define [
  'jquery',
  'Backbone'], ($, Backbone) ->
  Session = Backbone.Model.extend
    # Inspired by: https://github.com/ptnplanet/backbone-oauth

    initialize: (appId) ->
      @appId = appId
      @authUrl = @setupAuthUrl(window.apiServerUrl)
      @accessToken = localStorage['access_token']
      $.ajaxSetup
        type: 'POST',
        headers:  
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') 
          'Accept': 'application/json'
        dataType: 'json'
        beforeSend: (jqXHR, options) =>
          if @loggedIn()
            tokenHeader = "Bearer #{@accessToken}"
            jqXHR.setRequestHeader('Authorization', tokenHeader)

    logout: ->
      localStorage['access_token'] = ""

    loggedIn: ->
      if @accessToken? and @accessToken isnt "" and @accessToken isnt "undefined"
        true
      else
        false

    setupAuthUrl: (authServer) ->
      authUrl = "#{authServer}/oauth/authorize" 
      redirectUri = "#{window.location.protocol}//#{window.location.host}/redirect.html"
      redirectUri = encodeURIComponent(redirectUri)
      "#{authUrl}?client_id=#{@appId}&redirect_uri=#{redirectUri}&response_type=token"   

  Session
