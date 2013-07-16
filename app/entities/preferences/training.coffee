
define [
  'underscore'
  'backbone'
  './preferences'
],
(
  _
  Backbone
  Preferences
) ->

  _me = 'entities/preferences/training'

  Model = Backbone.Model.extend
    url: -> "#{window.apiServerUrl}/api/v1/users/-/preferences?type=TrainingPreference"

    defaults:
      type: "TrainingPreference"

    toJSON: (options) ->
      json = _.clone @attributes
      delete json.description
      json

    parse: (resp) ->
      return null unless resp
      # The server returns "true" and "false". Parse into bool
      if resp.data?
        for key, val of resp.data
          resp.data[key] = if val is "true" then true else false
      resp

#    parse: (resp) ->
#      return null unless resp
#      # Merge stored field values with field descriptions
#      fields = resp.description
#      for field in fields
#        field.value = resp.data[field.name]
#      @fields = new Preferences fields
#      @

    # ----------------------------------------------- Consumable API
    setValues: (values) ->
      return @ unless values
      data = @get('data') || {}
      data = _.extend data, values
      @set data:data
      @

  Model
