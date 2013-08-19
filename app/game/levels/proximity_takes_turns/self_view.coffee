define [
  'game/levels/circle_proximity/self_view'
  'text!./self_view.hbs'
],
(
  CircleProximitySelfView
  tmpl
) ->

  _userIconSel = '.user'


  View = CircleProximitySelfView.extend

    # ----------------------------------------------------- Class Extensions
    tmpl: tmpl


    # ----------------------------------------------------- Private Methods



    # ----------------------------------------------------- Consumable API
    getSelfCenter: ->
      return @_center if @_center
      $userIcon = @$(_userIconSel)
      @_center = {}
      @_center.x = $(window).width() / 2
      @_center.y = $userIcon.position().top
#      console.log center:@_center
      @_center

    getSelfRadius: ->
      @_rad = @_rad || @$el.height() / 2
      @_rad


  View

