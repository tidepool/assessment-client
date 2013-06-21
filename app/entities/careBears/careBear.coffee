define [
  'backbone'
], (
  Backbone
) ->

  _me = 'entities/careBears/careBear'

  Model = Backbone.Model.extend
    initialize: ->
      @on 'error', @onErr
      @on 'invalid', @onInvalid

    sync: ->
      return unless @url
      url = "#{@url}?#{$.param(@attributes)}"
#      console.log
#        url: url
      window.open url

    onErr: -> console.error "#{_me}: Trouble sharing"
    onInvalid: (model, err) -> console.error "#{_me}: Invalid: #{err}"
  Model




