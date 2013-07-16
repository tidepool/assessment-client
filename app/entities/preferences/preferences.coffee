
define [
  'backbone'
],
(
  Backbone
) ->

  PreferenceDescription = Backbone.Model.extend
    defaults:
      name: null
      description: null
      type: null
      category: null
      value: null

  Preferences = Backbone.Collection.extend
    model: PreferenceDescription

  Preferences
