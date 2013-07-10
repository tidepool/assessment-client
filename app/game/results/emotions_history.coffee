define [
  'backbone'
  'Handlebars'
  'game/results/base'
  'text!./emotions_history.hbs'
  'composite_views/perch'
  'game/results/emotions'
], (
  Backbone
  Handlebars
  ResultView
  tmpl
  perch
  EmotionsResultsView
) ->

  _holderSel = '.chartHolder'
  _scrollFixDelay = 200
  _emoticonSel = '.emoticon'
  _me = 'game/results/emotions_history'
  _tmpl = Handlebars.compile tmpl
  TIMECLASSES = [
    'time1-morning'
    'time2-earlyDay'
    'time3-lateDay'
    'time4-evening'
    'time5-night'
    'time6-lateNight'
  ]
  TIMESTRINGS = [
    'Morning'
    'Early Day'
    'Day'
    'Evening'
    'Night'
    'Late Night'
  ]

  _dateToTimeFeatureByArray = (dateString, array) ->
    date = new Date dateString
    hourPlayed = date.getHours() + 1 # Gets local hour from 0-23
    switch hourPlayed
      when 5,6,7,8     then return array[0]
      when 9,10,11,12  then return array[1]
      when 13,14,15,16 then return array[2]
      when 17,18,19,20 then return array[3]
      when 21,22,23,24 then return array[4]
      when 1,2,3,4     then return array[5]
      else                  return array[5]


  View = ResultView.extend
    className: 'emotionsHistory'
    events:
      'click .emoticon': 'onClickEmoticon'

    render: ->
      console.error "Need a collection" unless @collection?
      @listenTo @collection, 'sync', @renderChart
      @$el.append tmpl
      setTimeout (=> @$(_holderSel).scrollLeft 9999 ), _scrollFixDelay # Just scroll all the way right
      @

    renderChart: ->
      unless @collection.length # If there's no collection data, don't show the chart. Abort, ABORT!
        @remove()
        return
#      console.log collection: @collection.toJSON()
      # Set the time bucket for each item based on the time the game was played
      @collection.each (item) ->
        item.set 'timeClass', _dateToTimeFeatureByArray item.attributes.time_played, TIMECLASSES
        item.set 'timeString', _dateToTimeFeatureByArray item.attributes.time_played, TIMESTRINGS
      @$el.html _tmpl results: @collection.toJSON()
      @$(_emoticonSel).tooltip
        placement: 'right'
        container: 'body'
        html: true
        animation: false
#        trigger: 'click'

    onClickEmoticon: (e) ->
      id = $(e.target).data('id')
      console.log
        dataId: id
        model: @collection.get(id)
        attrs: @collection.get(id).attributes
        json: @collection.get(id).toJSON()

      perch.show
        title: 'Emotion Details'
        btn1Text: null
        content: new EmotionsResultsView
          model: new Backbone.Model @collection.get(id).attributes


  View

