define [
  'jquery'
  'backbone'
  'Handlebars'
  'text!./hold_please.hbs'
  'utils/numbers'
],
(
  $
  Backbone
  Handlebars
  tmpl
  numbers
) ->

  _me = 'ui_widgets/hold_please'
  _msgHolderSel = '.msg'
  _loadingMessages = [
    'Powering up the Flux Capacitor...'
    'Seeking the Keymaster...'
    'Venturing in the jungle for the golden statue...'
    'Seeking the lost ark...'
    'Finding the secret plans...'
    'Wax on, wax off...'
    'Recieving signal from a galaxy far, far away...'
    'Seeking the sourthern oracle...'
    'Evading the nothing...'
    'Microwaving the potato...'
    'Getting on the highway to the danger zone...'
    'Pulling baby out of the corner...'
    'Phoning home...'
    'Getting loose. Footloose...'
    'Feeding Seymore...'
    'Just a jump the the left and a step to the right. More to go...'
  ]

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

    _addMsg: (msg) ->
      if msg
        msg = numbers.pickOneAnyOne _loadingMessages if msg is true
        $(".#{@className} #{_msgHolderSel}").text msg # This odd selector is because we're cloning the element, so we don't have a reference to it

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
    show: (selector, msg) ->
      if selector then @_showOnSelector selector else @_showFullScreen()
      @_addMsg msg
    hide: (selector) ->
      if selector then @_hideInSelector selector else @_hideAll()

  new Me()