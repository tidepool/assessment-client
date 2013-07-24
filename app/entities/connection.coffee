define [
  'classes/model'
],
(
  Model
) ->

  _linkRoot = "#{window.apiServerUrl}/auth/new?"
  PROVIDERNAMES =
    'fitbit': 'FitBit'
    'nike': 'Nike'
    'facebook': 'Facebook'
    'twitter': 'Twitter'


  Export = Model.extend

    defaults: ->
      redirect_uri: document.URL
      link: 'javascript:void(0);'

    initialize: ->
      @_setLink()
      @set 'display_name', PROVIDERNAMES[@attributes.provider] || @attributes.provider

    _setLink: ->
      params = @pick 'provider', 'redirect_uri', 'user_id'
      @set link: "#{_linkRoot}#{$.param params}"

#    setupAddAuthUrl: (provider) ->
#      "#{authUrl}?redirect_uri=#{redirectUri}&user_id=#{@get('id')}&provider=#{provider}"

  Export

