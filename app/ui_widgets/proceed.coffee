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

  Me = Backbone.View.extend
    tagName: 'button'
    className: 'proceed'
    events:
      "click": "onClick"
    initialize: ->
      _.bindAll @, 'show', 'hide'

    render: ->
      return if @$el.is(':visible') # don't rerender or animate if it's already visible
      @$el.html tmpl
      $(_parentSel).append @el
      @delegateEvents()
      @_animateIn()
      @

    _animateIn: ->
      @$el.removeClass 'bounceIn'
      setTimeout => #This is done in a set timeout so that the browser notices the class change and triggers the transition
        @$el.addClass 'bounceIn',
        1

    # Event Handlers
    onClick: (e) ->
      #console.log "#{_me}.onClick()"
      @trigger 'click'

    # Public API
    show: -> @render()
    hide: -> @remove()

  new Me()