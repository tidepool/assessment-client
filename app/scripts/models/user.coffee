define [
  'underscore'
  'backbone'
],
(
  _
  Backbone
) ->

  _me = 'models/user'

  User = Backbone.Model.extend
    urlRoot: ->
      "#{window.apiServerUrl}/api/v1/users"

    initialize:  ->
      @on 'all', (e) -> console.log "#{_me} event: #{e}"

    isGuest: ->
      @get('guest')

    parseHash: (hash) ->
      params = {}
      queryString = hash.substring(1)
      regex = /([^&=]+)=([^&]*)/g
      while (m = regex.exec(queryString)) 
        params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
      params

    addAuthentication: (provider, popupWindowSize) ->
      left = window.screenLeft + 50 
      top = window.screenTop + 50
      width = popupWindowSize.width
      height = popupWindowSize.height
      window.addAuthRedirect = _.bind(@onAddAuthRedirect, @)
      window.open(@setupAddAuthUrl(provider), "Login", "width=#{width}, height=#{height}, left=#{left}, top=#{top}, menubar=no")

    setupAddAuthUrl: (provider) ->
      authUrl = "#{window.apiServerUrl}/auth/additional"

      redirectUri = "#{window.location.protocol}//#{window.location.host}/additional_redirect.html#"
      redirectUri = encodeURIComponent(redirectUri)
      provider_param = "provider=#{provider}&"
      "#{authUrl}?redirect_uri=#{redirectUri}&user_id=#{@get('id')}&provider=#{provider}"   

    onAddAuthRedirect: (hash, location) ->
      # http://assessments-front.dev/additional_redirect.html#user_id=113&provider=twitter 
      console.log("onAddAuthRedirect called with #{location} and hash #{hash}")
      params = @parseHash(hash)
      console.log("params are: #{params['user_id']} and #{params['provider']}")
      @trigger('user:authentication_added', params['provider'])

  User
