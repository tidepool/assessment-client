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

    className: 'billboard'


    # ----------------------------------------------------- Consumable API
    # Slide new text in with a circle
    slideIn: (model) ->
      @$el.append _tmpl model.attributes
      $label = @$(_labelSel)
      setTimeout (-> $label.addClass _onDeckClass), 1

    # Drop the current text down
    focusOut: ->
      $label = @$ _labelSel
      $label.addClass _focusOutClass
      setTimeout (-> $label.remove()), _animTime
      @

    # Bring new text in
    focusIn: (model) ->
      $label = $ _tmpl _.extend model.attributes, { className: "#{_aboveClass} #{_onDeckClass}" }
      @$el.append $label
      setTimeout (-> $label.removeClass _aboveClass), 1

  View

