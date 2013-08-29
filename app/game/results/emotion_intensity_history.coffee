define [
  'backbone'
  'Handlebars'
  'game/results/base'
  'text!./emotions_history.hbs'
  'bower_components/highcharts.com/js/highcharts.src'
], (
  Backbone
  Handlebars
  ResultView
  tmpl
  x_highcharts
) ->

  _holderSel = '.chartHolder'
  _me = 'game/results/emotion_intensity_history'
  _fakeData = [
    { day: 'Jan 1st, 2013', value: 60 }
    { day: '2', value: 70 }
    { day: '3', value: 30 }
    { day: '4', value: 20 }
    { day: '5', value: 40 }
    { day: '6', value: 60 }
    { day: '7', value: 75 }
    { day: '8', value: 80 }
    { day: '9', value: 60 }
    { day: 'July 7th, 2013', value: 50 }
  ]


  View = ResultView.extend
    className: 'emotionIntensityHistory'

    render: ->
#      console.error "Need a collection" unless @collection?
      @collection = new Backbone.Collection _fakeData
      @$el.append tmpl
      #@listenTo @collection, 'sync', @renderChart
      setTimeout @renderChart, 300
      return this

    renderChart: ->
#      console.log "#{_me}.renderChart()"
      #unless @collection.length # If there's no collection data, don't show the chart. Abort, ABORT!
      #  @remove()
      #  return
      categories = []
      data = []
      _.each _fakeData, (d) ->
        categories.push d.day
        data.push d.value

      $(_holderSel).highcharts
        chart:
          type: 'area'
          height: 200
          spacingLeft: 0
          spacingRight: 0
        title: text: null
        xAxis:
          categories: categories
          labels: enabled: false
#          showFirstLabel: true
#          showLastLabel: true
          tickLength: 0
          tickWidth: 0
        yAxis:
          min: 0
          max: 100
          tickInterval: 50
          title:
            text: null #'Precentile'
        tooltip:
          valueSuffix: '%'
        legend: enabled: false
        credits: enabled: false
        plotOptions:
          series:
            animation: false
            color: '#3b3b41'
            fillColor: 'rgba(248,109,24,.25)'
            negativeColor: '#3b3b41'
            negativeFillColor: 'rgba(24,143,244,.25)'
            threshold: 50
        series: [
          name: 'Intensity'
          data: data
        ]



  View


