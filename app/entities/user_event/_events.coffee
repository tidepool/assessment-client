define [
  'backbone'
  'classes/model'
  'core'
], (
  Backbone
  Model
  app
) ->

  OneEvent = Model.extend

    defaults: ->
      {
        event: null # The name of the event
        time: (new Date()).getTime()
        timezone_offset: (new Date).getTimezoneOffset()
      }

    initialize: ->
      @on 'invalid', (model, err) -> console.warn "event model invalid: #{err}"

    validate: (attrs, options) ->
      return 'Requires the `event` property' unless attrs.event
      return null # no errors

  Export = Backbone.Collection.extend
    model: OneEvent


  Export


