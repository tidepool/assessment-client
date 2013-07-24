
define [
  'underscore'
  'classes/model'
],
(
  _
  Model
) ->

  _me = 'entities/preferences/training'

  Export = Model.extend
    url: -> "#{window.apiServerUrl}/api/v1/users/-/preferences?type=TrainingPreference"

    defaults:
      type: "TrainingPreference"

    toJSON: (options) ->
      json = _.clone @attributes
      delete json.description
      json

    parse: (resp, options) ->
      resp = @dewrap resp # dewrap is from the extended/parent object
      return null unless resp
      # The server returns "true" and "false". Parse into bool
      if resp.data?
        for key, val of resp.data
          resp.data[key] = if val is "true" then true else false
      resp


    # ----------------------------------------------- Consumable API
    setValues: (values) ->
      return @ unless values
      data = @get('data') || {}
      data = _.extend data, values
      @set data:data
      @

  Export
