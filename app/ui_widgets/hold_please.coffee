define [
  'jquery'
  'Backbone'
  'Handlebars'
  "text!./hold_please.hbs"
],
(
  $
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'ui_widgets/hold_please'

  Me = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    tagName: 'b'
    className: 'holdPlease'
    events:
      "click": "_clicked"
    initialize: ->
      @render()
    render: ->
      @$el.html @tmpl()
      console.log @el
    _clicked: (e) ->
      e.preventDefault()
      e.stopPropagation()

    # Public API
    show: (selector) -> $(selector).css('position', 'relative').append @el
    hide: -> @$el.remove()


  new Me()