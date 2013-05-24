define [
  'jquery'
  'backbone'
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
    # Optionally pass in a font-awesome icon size http://fortawesome.github.io/Font-Awesome/examples/#larger-icons
    render: (iconSize) ->
      @$el.html @tmpl
        iconSize: iconSize
      @
    _clicked: (e) ->
      e.preventDefault()
      e.stopPropagation()

    _showOnSelector: (selector, iconSize) ->
      #Use a small icon for buttons that aren't large
      iconSize = 'icon-large' if $(selector).hasClass('btn-large')
      $(selector)
        .addClass('onHold')
        .css('position', 'relative')
        .append @render(iconSize).$el.clone(true) # a .clone(true) sends the event handlers too, important if we want to catch and block click events on loading elements

    _showFullScreen: ->
      @_showOnSelector 'body', 'icon-4x'

    _hideInSelector: (selector) ->
      $(selector)
        .removeClass('onHold')
        .css('position', '')
        .find(".#{@className}").remove()

    _hideAll: ->
      $(".#{@className}")
        .parent()
          .removeClass('onHold')
          .css('position', '')
      $(".#{@className}").remove()


    # Public API
    show: (selector) ->
      if selector then @_showOnSelector selector else @_showFullScreen()
    hide: (selector) ->
      if selector then @_hideInSelector selector else @_hideAll()

  new Me()