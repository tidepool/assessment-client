define [
  'underscore'
  'backbone'
],
(
  _
  Backbone
) ->


  Model = Backbone.Model.extend

    # Remove the wrapper around the response if it is present
    dewrap: (resp, options) ->
      # Return the data directly if it is there
      if _.isObject(resp.data) and _.isObject(resp.status)
        resp.data
      else
        resp

    # Default parse behavior is to dewrap
    parse: (resp, options) ->
      resp = @dewrap resp, options
#      console.log resp:resp
      # TODO: handle blank/null
      # TODO: handle empty results
      resp

    # Take a property and add 1 to it, if it is a number
    increment: (property) ->
      val = @get property
      return if isNaN val
      @set property, val + 1


  Model
