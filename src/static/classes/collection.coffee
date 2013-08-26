define [
  'underscore'
  'backbone'
  'classes/model'
],
(
  _
  Backbone
  Model
) ->


  Collection = Backbone.Collection.extend
    model: Model
    dewrap: Model.prototype.dewrap
    parse: Model.prototype.parse
    mixalot: ->
      #TODO: Test
      @reset @shuffle(), { silent:true }
      @

  Collection
