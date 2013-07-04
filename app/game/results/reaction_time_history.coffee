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


  View = ResultView.extend
    className: 'reactionTimeHistory'

    render: ->
      console.error "Need a collection" unless @collection?
      @listenTo @collection, 'sync', @renderChart
      return this

    renderChart: ->
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
      maxVal = @collection.max (model) -> model.attributes.score.slowest_time
      maxVal = maxVal.attributes.score.slowest_time
      console.log maxVal:maxVal
      @collection.max = maxVal
      @collection.min = 0
      Handlebars.registerHelper 'normalizeReactionTime', (score) ->
        max = maxVal
        min = 0
        normalScore = (score - min) / (max - min) * 100
        normalScore = if normalScore > 95 then 95 else normalScore
        return Math.round normalScore
      @tmpl = Handlebars.compile tmpl

    onTooltipShow: ($tip, $el) ->
      $tip.addClass $el.prop 'class' # color the tooltip to match the fastest/slowest colors

  View


