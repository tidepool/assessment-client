define [
  'backbone'
  'Handlebars'
  'game/results/base'
  'text!./emotions_history.hbs'
], (
  Backbone
  Handlebars
  ResultView
  tmpl
) ->

  _holderSel = '.chartHolder'
  _me = 'game/results/emotions_history'
  _fakeData = [
    { emotion: 'amused',     title: 'Amused',   datetime: new Date() }
    { emotion: 'happiness',  title: 'Happy',    datetime: new Date() }
    { emotion: 'anger',      title: 'Angry',    datetime: new Date() }
    { emotion: 'relief',     title: 'Relieved', datetime: new Date() }
    { emotion: 'sexypants',  title: 'Sexual',   datetime: new Date() }
    { emotion: 'anger',      title: 'Sexual',   datetime: new Date() }
    { emotion: 'anger',      title: 'Sexual',   datetime: new Date() }
    { emotion: 'anger',      title: 'Sexual',   datetime: new Date() }
  ]

  View = ResultView.extend
    className: 'emotionsHistory'

    render: ->
#      console.error "Need a collection" unless @collection?
      @collection = new Backbone.Collection _fakeData
      @$el.append tmpl
      #@listenTo @collection, 'sync', @renderChart
      @renderChart()
      return this

    renderChart: ->
#      console.log "#{_me}.renderChart()"
      #unless @collection.length # If there's no collection data, don't show the chart. Abort, ABORT!
      #  @remove()
      #  return


  View

