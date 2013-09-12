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

  EVENTS =
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
    selected:          'selected'
    deselected:        'deselected'
    readyToProceed:    'ready_to_proceed'
    notReadyToProceed: 'not_ready_to_proceed'
    summary:           'level_summary'
    end:               'level_completed'


  Export = Model.extend
    defaults: ->
      {
        event_type: null # The string id of the level type (eg: 'image_rank')
        stage: null # The index of the level instance (eg: 0 is the first level in the game)
        events: new Events()
        timezone_offset: (new Date).getTimezoneOffset()
        is_touch: detect.isTouch()
        is_phone_width: detect.isPhone()
      }


    # --------------------------------------------------- Backbone Methods
    initialize: ->
      throw new Error 'Need event_type'               unless @attributes.event_type
      throw new Error 'event_type should be a string' unless typeof @attributes.event_type is 'string'
      throw new Error 'Need stage as a number'        unless typeof @attributes.stage is 'number'
      @_translateEventType()

    validate: (attrs, options) ->
      return 'Can\'t save unless there is at least 1 event' unless attrs.events.length > 0
      return null # no errors

    toJSON: (options) ->
      attrs = _.clone(this.attributes)
      attrs.events = attrs.events.toJSON()
      attrs


    # --------------------------------------------------- Private Methods
    _translateEventType: ->
      newET = _viewNameToModuleName[ @attributes.event_type ]
      @set event_type:newET if newET?
      @


    # --------------------------------------------------- Consumable API
    record: (eventData, options) ->
      @attributes.events.add eventData, _.extend({validate:true}, options)
      # ------------------------------------------------------ v Line of Awesome
#      console.log eventData # Uncomment this to view real-time details of every recorded user event
#      console.log eventBundle: @toJSON()
      # ------------------------------------------------------ ^ Line of Awesome
      @

  Export.EVENTS = EVENTS
  Export


