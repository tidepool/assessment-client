define [
  'underscore'
  'classes/model'
  './_events'
  'utils/detect'
  'core'
], (
  _
  Model
  Events
  detect
  app
) ->

  _viewNameToModuleName =
    ImageRank: 'image_rank'
    CirclesTest: 'circles_test'
    ReactionTime: 'reaction_time'
    Survey: 'survey'
    Snoozer: 'snoozer'
    EmotionsCircles: 'emotions_circles'
    InterestPicker: 'interest_picker'

  _EVENTS =
    start:             'level_started'
    instructions:      'show_instructions'
    sublevelStart:     'sublevel_initialize'
    moveStart:         'start_move'
    moveEnd:           'end_move'
    interact:          'interacted'
    change:            'changed'
    resize:            'resized'
    shown:             'shown'
    decoy:             'decoy'
    miss:              'miss'
    correct:           'correct'
    incorrect:         'incorrect'
    readyToProceed:    'ready_to_proceed'
    notReadyToProceed: 'not_ready_to_proceed'
    summary:           'level_summary'
    end:               'level_completed'


  Export = Model.extend
    url: -> "#{app.cfg.apiServer}/api/v1/users/-/games/#{@attributes.game_id}/event_log"
    isNew: -> false # Always do a PUT, not a POST
    defaults: ->
      {
        event_type: null # The string id of the level type (eg: 'image_rank')
        stage: null # The index of the level instance (eg: 0 is the first level in the game)
        events: new Events()
        timezone_offset: (new Date).getTimezoneOffset()
        is_touch: detect.isTouch()
      }


    # --------------------------------------------------- Backbone Methods
    initialize: ->
#      console.log eventBundle: @
      throw new Error 'Need event_type' unless @attributes.event_type
      throw new Error 'event_type should be a string' unless typeof @attributes.event_type is 'string'
      throw new Error 'Need stage as a number' unless typeof @attributes.stage is 'number'
      throw new Error 'Need game_id' unless @attributes.game_id
#      @on 'sync', @onSync
      @on 'error', @onErr
      @_translateEventType()

    validate: (attrs, options) ->
      return 'Can\'t save unless there is at least 1 event' unless attrs.events.length > 0
      return null # no errors

    toJSON: (options) ->
      attrs = _.clone(this.attributes)
      attrs.events = attrs.events.toJSON()
      event_log: attrs


    # --------------------------------------------------- Private Methods
    _translateEventType: ->
      newET = _viewNameToModuleName[ @attributes.event_type ]
      @set event_type:newET if newET?
      @


    # --------------------------------------------------- Event Handling
#    onSync: (model) -> console.log model.attributes
    onErr: -> throw new Error 'Error syncing user_event'


    # --------------------------------------------------- Consumable API
    record: (eventData, options) ->
      @attributes.events.add eventData, _.extend({validate:true}, options)
      # ------------------------------------------------------ v Line of Awesome
      # Uncomment this to view real-time details of every recorded user event
#      console.log
#        eventBundle: @toJSON()
#        eventData: eventData
      # ------------------------------------------------------ ^ Line of Awesome
      @

  Export.EVENTS = _EVENTS
  Export


