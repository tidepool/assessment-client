define [
  'backbone'
  'classes/model'
],
(
  Backbone
  Model
) ->

  # A Single Game Level
  Level = Model.extend
    defaults:
      friendly_name: 'Default Level Name'
      isComplete: false
    initialize: ->
      instructions = @get 'instructions'
      instructionsBrief = if instructions instanceof Array then instructions[0] else instructions
      @set 'instructionsBrief', instructionsBrief

  # A Collection of Game Levels
  Collection = Backbone.Collection.extend
    model: Level
    setComplete: (LevelId) ->
      level = @at LevelId
      level.set('isComplete', true) if level?

  Collection




