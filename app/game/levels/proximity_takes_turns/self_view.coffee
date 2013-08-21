define [
  'jquery'
  'game/levels/circle_proximity/self_view'
  'text!./self_view.hbs'
],
(
  $
  CircleProximitySelfView
  tmpl
) ->

  _userIconSel = '.user'
  _ringSel = '.zoneSelf .ring'
  _overSelfClass = 'overSelf'
  _overRing1Class = 'overRing1'

  View = CircleProximitySelfView.extend

    # ----------------------------------------------------- Class Extensions
    tmpl: tmpl


    # ----------------------------------------------------- Private Methods



    # ----------------------------------------------------- Consumable API
    getRingCenter: ->
      @$ring = @$ring || $(_ringSel)
      selfRingCenter =
        x: $(window).width() / 2
        y: @$ring.position().top + @$ring.height() / 2
      selfRingCenter

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

    # Based on how far away the incoming object is, react differently
    incoming: (distance) ->
#      console.log distance
      @$ring = @$ring || $(_ringSel)
      radius = @$ring.height() / 2
      @$ring.toggleClass _overSelfClass, distance <= radius
      boxShadow = parseInt @$ring.css('box-shadow').split(' ').pop() # If it's over the box-shadow, that's the outer ring
      if boxShadow
        outerRadius = boxShadow + radius
      else
        outerRadius = radius*2
      @$ring.toggleClass _overRing1Class, distance <= outerRadius
      @

    clearHighlights: ->
      @$ring = @$ring || $(_ringSel)
      @$ring.removeClass "#{_overSelfClass} #{_overRing1Class}"
      @

  View

