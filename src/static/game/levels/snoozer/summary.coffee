define [
  'underscore'
  'classes/model'
  'utils/detect'
],
(
  _
  Model
  detect
) ->

  Export = Model.extend
    defaults:
      total: null
      decoys: null
      correct: 0
      incorrect: 0
      missed: 0
      reaction_times: []


    # ----------------------------------------------------- Backbone Extensions
    initialize: ->
#      @on 'change', (e) -> console.log e
      @set 'is_touch', detect.isTouch()


    # ----------------------------------------------------- Consumable
    addTime: (reactionTime) ->
      rt = @get 'reaction_times'
      rt.push reactionTime
      @set reaction_times:rt

    # calculate averages and such
    calculate: ->
      times = @get 'reaction_times'
      return unless times.length
      @set fastest_time: _.min times
      @set slowest_time: _.max times
      sum = _.reduce times, (memo, num) -> memo + num
      @set average_time: sum / times.length
      @

  Export

