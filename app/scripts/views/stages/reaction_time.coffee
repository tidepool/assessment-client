define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars',
  'models/user_event',
  "text!./reaction_time.hbs",
  'models/assessment'], ($, _, Backbone, Handlebars, UserEvent, tempfile) ->
  ReactionTime = Backbone.View.extend
    events:
      "click #start": "startTest",
      "click #circle": "circleClicked"

    initialize: (options) ->
      @stageNo = options.stageNo
      @assessment = options.assessment
      @colors = @model.get('colors')
      @sequenceType = @model.get('sequence_type')
      @colorSequence = @prepareSequence()
      @sequenceNo = -1
      @numOfSequences = @colorSequence.length

    prepareSequence: ->
      numberOfReds = parseInt @model.get('number_of_reds')
      intervalFloor = parseInt @model.get('interval_floor')
      intervalCeil = parseInt @model.get('interval_ceil')
      limitTo = parseInt @model.get('limit_to')
      max = @colors.length - 1
      min = 0
      redCount = 0
      yellowCount = 0
      count = 0
      sequence = []
      exit = false
      priorColor = 'green'
      
      # TODO: Refactor this!
      while (not exit)
        timeInterval = Math.floor(Math.random() * (intervalCeil - intervalFloor + 1) + intervalFloor)
        outcome = Math.floor(Math.random() * (max - min + 1) + min)
        switch @sequenceType
          when "simple"
            color = @colors[outcome]
            if color is 'red'
              redCount += 1
            if redCount > numberOfReds or count > limitTo
              # Always force the last one to be red
              exit = true
              color = 'red'

            sequence[count] = { color: color, interval: timeInterval } 
          when "complex"
            if @colors[outcome] is "yellow"
              yellowCount +=1
            priorColor = sequence[count - 1].color if count > 0
            sequence[count] = { color: @colors[outcome], interval: timeInterval } 
            if @colors[outcome] is 'red' and priorColor is 'yellow'
              exit = true
            else if yellowCount is 3 and @colors[outcome] is 'yellow'
              # Force the red outcome if there are already 3 yellows
              exit = true
              count += 1
              timeInterval = Math.floor(Math.random() * (intervalCeil - intervalFloor + 1) + intervalFloor)
              sequence[count] = { color: "red", interval: timeInterval }
            else if count > limitTo - 1
              # force read after yellow after the limit is reached
              exit = true
              sequence[count] = { color: "yellow", interval: timeInterval }
              timeInterval = Math.floor(Math.random() * (intervalCeil - intervalFloor + 1) + intervalFloor)
              sequence[count + 1] = { color: "red", interval: timeInterval } 
        count += 1

      sequence

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template({instructions: @model.get('instructions')}))
      $(".login_logout").css("visibility", "hidden")
      $("#infobox").css("visibility", "visible")
      this

    waitAndShow: ->
      boundShowCircle = _.bind @showCircle, @
      setTimeout boundShowCircle, @colorSequence[@sequenceNo + 1].interval

    startTest: ->
      colorSequenceInString = (color.color + ":" + color.interval for color in @colorSequence)[..]
      @createUserEvent
        "event_desc": "test_started"
        "color_sequence": colorSequenceInString
      $("#infobox").css("visibility", "hidden")
      @waitAndShow()

    showCircle: ->
      @sequenceNo += 1
      if @sequenceNo < @numOfSequences
        @createUserEvent
          "event_desc": "circle_shown"
          "circle_color": @colorSequence[@sequenceNo].color
          "sequence_no": @sequenceNo
          "time_interval": @colorSequence[@sequenceNo].interval
        $("#circle").css("background-color", @colorSequence[@sequenceNo].color)
        next_seq = @sequenceNo + 1
        if next_seq < @numOfSequences
          @waitAndShow()

    circleClicked: ->
      switch @sequenceType
        when "simple"
          if @colorSequence[@sequenceNo].color is 'red'
            @createUserEvent
              "event_desc": "correct_circle_clicked"
              "circle_color": @colorSequence[@sequenceNo].color
              "sequence_no": @sequenceNo         
          else
            @createUserEvent
              "event_desc": "wrong_circle_clicked"
              "circle_color": @colorSequence[@sequenceNo].color
              "sequence_no": @sequenceNo        
        when "complex"
          if @sequenceNo > 0 and @colorSequence[@sequenceNo - 1].color is 'yellow' and @colorSequence[@sequenceNo].color is 'red'
            @createUserEvent
              "event_desc": "correct_circle_clicked"
              "circle_color": @colorSequence[@sequenceNo].color
              "sequence_no": @sequenceNo        
          else
            @createUserEvent
              "event_desc": "wrong_circle_clicked"
              "circle_color": @colorSequence[@sequenceNo].color
              "sequence_no": @sequenceNo

      if (@sequenceNo is @numOfSequences - 1)
        @createUserEvent
          "event_desc": "test_completed"
          "sequence_no": @sequenceNo
        @assessment.updateProgress(@stageNo + 1)
        # Backbone.history.navigate("/stage/#{@nextStage}", true)
   
    createUserEvent: (newEvent) ->
      eventInfo = 
        "assessment_id": @assessment.get('id')
        "module": "reaction_time"
        "stage": @stageNo
        "sequence_type": @sequenceType
      fullInfo = _.extend({}, eventInfo, newEvent)
      userEvent = new UserEvent()
      userEvent.send(fullInfo)
      
  ReactionTime