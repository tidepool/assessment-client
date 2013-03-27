define [
  'jquery',
  'Backbone'], ($, Backbone) ->
  Session = Backbone.Model.extend
    # Inspired by: https://github.com/ptnplanet/backbone-oauth

    initialize: (authServer, appId) ->
      @appId = appId
      @authUrl = @setupAuthUrl(authServer)
      @accessToken = localStorage['access_token']
      # @setupAjaxPrefilter()
      $.ajaxSetup
        type: 'POST',
        headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
        dataType: 'json'
        beforeSend: (jqXHR, options) =>
          if @loggedIn()
            tokenHeader = "Bearer #{@accessToken}"
            jqXHR.setRequestHeader('Authorization', tokenHeader)
            # opts = {}
            # if options.data?
            #   opts = JSON.parse(options.data)
            #   newOpts = JSON.stringify($.extend(opts, { access_token: @accessToken }))
            #   options.data = newOpts
            # else
            #   newOpts = $.param({ access_token: @accessToken })
            #   options.processData = false
            #   options.data = newOpts


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

    setupAjaxPrefilter: =>
      $.ajaxPrefilter (options, originalOptions, jqXHR) => 
        if @accessToken?
          newOpts = JSON.stringify($.extend(JSON.parse(originalOptions.data), { access_token: @accessToken }))
          options.data = newOpts

  Session
