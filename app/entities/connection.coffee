define [
  'classes/model'
  'entities/progress/connection'
],
(
  Model
  ConnectionProgress
) ->

  _linkRoot = "#{window.apiServerUrl}/auth/new?"
  PROVIDERNAMES =
    'fitbit': 'Fitbit'
    'nike': 'Nike'
    'facebook': 'Facebook'
    'twitter': 'Twitter'
    'instagram': 'Instagram'


  Export = Model.extend

    defaults: ->
      redirect_uri: document.URL
      link: 'javascript:void(0);'

    initialize: ->
      @progress = new ConnectionProgress provider: @attributes.provider
      @listenTo @progress, 'error', @onProgressError
      @listenTo @progress, 'sync', @onProgressSync
      @_setActivationLink()
      @set 'display_name', PROVIDERNAMES[@attributes.provider] || @attributes.provider

    _setActivationLink: ->
      params = @pick 'provider', 'redirect_uri', 'user_id'
      @set link: "#{_linkRoot}#{$.param params}"

    onProgressError: (progressModel, msg) ->
#      app.analytics.track 'entities/connection', 'Error getting progress'
      console.warn "Error getting progress on the connection: #{msg}"
      @unset 'isPolling'
      @set msg:'Error Syncing'

    onProgressSync: (progressModel) ->
#      console.log
#        progModel: progressModel.attributes
#        this: @attributes
      @unset 'msg'
      @unset 'isPolling'


    # ----------------------------------------------------------- Public
    syncConnection: ->
      @set msg:'Syncing...'
      @set isPolling:true
      @progress.fetch()

  Export

