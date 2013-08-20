define [
  'jquery'
  'backbone'
  'text!./proceed.hbs'
],
(
  $
  Backbone
  tmpl
) ->

  _me = 'ui_widgets/proceed'
  _parentSel = 'body'
  _rightKey = 39

  Me = Backbone.View.extend
    tagName: 'button'
    className: 'proceed'
    events:
      "click": "onClick"
    initialize: ->
      _.bindAll @, 'show', 'hide', 'onKeydown'


    render: ->
      return if @$el.is(':visible') # don't rerender or animate if it's already visible
      @$el.html tmpl
      $(_parentSel).append @el
      @delegateEvents()
      @_animateIn()
      $(window).on 'keydown', @onKeydown
      @

    _animateIn: ->
      @$el.removeClass 'bounceIn'
      setTimeout => #This is done in a set timeout so that the browser notices the class change and triggers the transition
        @$el.addClass 'bounceIn',
        1

    # Event Handlers
    onClick: (e) ->
#      console.log "#{_me}.onClick()"
      @trigger 'click'

    onKeydown: (e) ->
      code = event.charCode || event.which
      switch code
        when _rightKey then @$el.trigger 'click'


    # ----------------------------------------- API for Consumption
    show: -> @render()
    hide: ->
      $(window).off 'keypress', @onKeydown
      @remove()

  new Me()