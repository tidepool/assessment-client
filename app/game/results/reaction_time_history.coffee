define [
  'backbone'
  'Handlebars'
  'game/results/base'
  'text!./reaction_time_history.hbs'
], (
  Backbone
  Handlebars
  ResultView
  tmpl
) ->

  _holderSel = '.chartHolder'
  _barSel = '.bar'
  _scrollFixDelay = 50
  _me = 'game/results/reaction_time_history'
  _minSpeed = 190 # Start drawing the graph at this point. No human besides Luke Skywalker can be faster than this.


  View = ResultView.extend
    className: 'reactionTimeHistory'

    render: ->
      console.error "Need a collection" unless @collection?
      @listenTo @collection, 'sync', @renderChart
      return this

    renderChart: ->
#      console.log "#{_me}.renderChart()"
      unless @collection.length # If there's no collection data, don't show the chart. Abort, ABORT!
        @remove()
        return

      @_compileTemplateForData() # Because the upper range should reflect the max for this data set, we need to compile the template every data sync
      @$el.html @tmpl
        max: @collection.max
        min: @collection.min
        results: @collection.toJSON()
      @_addCallbackToTooltipShow()
      @$(_barSel).tooltip
        placement: 'right'
        container: 'body'
        html: true
        animation: false
        afterShow: _.bind @onTooltipShow, @
      setTimeout (=> @$(_holderSel).scrollLeft 9999 ), _scrollFixDelay # Just scroll all the way right

    # http://www.silviarebelo.com/2013/03/adding-callbacks-to-twitter-bootstraps-javascript-plugins/
    _addCallbackToTooltipShow: ->
      superShow = $.fn.tooltip.Constructor.prototype.show
      $.fn.tooltip.Constructor.prototype.show = ->
        superShow.call this
        @options.afterShow?(@$tip, @$element)

    _compileTemplateForData: ->
      if @collection.at(0).attributes.score?
        maxVal = @collection.max (model) -> model.attributes.score.fastest_time
        maxVal = maxVal.attributes.score.fastest_time
      else
        maxVal = 9999 # handles an unusual server response without a JS error
      @collection.max = maxVal
      @collection.min = _minSpeed
      Handlebars.registerHelper 'normalizeReactionTime', (score) ->
        max = maxVal
        min = _minSpeed
        normalScore = (score - min) / (max - min) * 100
        normalScore = if normalScore > 95 then 95 else normalScore
        return Math.round normalScore
      @tmpl = Handlebars.compile tmpl

    onTooltipShow: ($tip, $el) ->
      $tip.addClass $el.prop 'class' # color the tooltip to match the fastest/slowest colors

  View


