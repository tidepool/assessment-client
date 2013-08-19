define [
  'jquery'
  'backbone'
  'Handlebars'
],
(
  $
  Backbone
  Handlebars
) ->

  _tmpl = Handlebars.compile "<label class='{{className}}'>{{trait1}} <span class='muted'>/</span> {{trait2}}</label>"
  _onDeckClass = 'onDeck'
  _focusOutClass = 'focusOut'
  _aboveClass = 'above'
  _animTime = 200
  _labelSel = 'label'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'billboard'

    initialize: ->

    render: ->
      @

    # ----------------------------------------------------- Private Methods

    # ----------------------------------------------------- UI Events


    # ----------------------------------------------------- Data Events

    # ----------------------------------------------------- Consumable API
    # Slide new text in with a circle
    slideIn: (model) ->
      @$el.append _tmpl model.attributes
      setTimeout (=> @$(_labelSel).addClass _onDeckClass), 4

    # Drop the current text down
    focusOut: ->
      $label = @$ _labelSel
      $label.addClass _focusOutClass
      setTimeout (-> $label.remove()), _animTime
      @

    # Bring new text in
    focusIn: (model) ->
      console.log 'focus in'
      $label = $ _tmpl _.extend model.attributes, { className: "#{_aboveClass} #{_onDeckClass}" }
      @$el.append $label
      setTimeout (-> $label.removeClass _aboveClass), 4

  View

