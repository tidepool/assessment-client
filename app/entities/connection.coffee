define [
  'backbone'
],
(
  Backbone
) ->



  Model = Backbone.Model.extend

    urlRoot: "#{window.apiServerUrl}/auth/new?"

    defaults: ->
      user_id: null
      redirect_uri: document.URL #"#{window.location.protocol}//#{window.location.host}/additional_redirect.html"
      provider: 'fitbit'
      display_name: 'Fitbit'
      isActive: false
      link: 'javascript:void(0);'

    initialize: ->
      @_setLink()

    _setLink: ->
      params = @pick 'provider', 'redirect_uri', 'user_id'
      @set link: "#{@urlRoot}#{$.param params}"

    setupAddAuthUrl: (provider) ->
      "#{authUrl}?redirect_uri=#{redirectUri}&user_id=#{@get('id')}&provider=#{provider}"

#    onAddAuthRedirect: (hash, location) ->
#      # additional_redirect.html#user_id=113&provider=twitter
#      console.log("onAddAuthRedirect called with #{location} and hash #{hash}")
#      params = @parseHash(hash)
#      console.log("params are: #{params['user_id']} and #{params['provider']}")
#      @trigger('user:authentication_added', params['provider'])


  Model



