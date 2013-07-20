define [
  'underscore'
  'backbone'
],
(
  _
  Backbone
) ->

  Model = Backbone.Model.extend
    defaults:
      total: null
      decoys: null
      correct: 0
      incorrect: 0
      missed: 0
      reactionTimes: []

    # ----------------------------------------------------- Backbone Extensions
    initialize: ->


    # ----------------------------------------------------- Consumable
    # TODO: Abstract into a base class
    increment: (property) -> @set property, @get(property) + 1

    addTime: (reactionTime) ->
      rt = @get 'reactionTimes'
      rt.push reactionTime
      @set reactionTimes:rt

    # calculate averages and such
    calculate: ->
      times = @get 'reactionTimes'
      return unless times.length
      @set fastest_time: _.min times
      @set slowest_time: _.max times
      sum = _.reduce times, (memo, num) -> memo + num
      @set average_time: sum / times.length
      @

  Model

