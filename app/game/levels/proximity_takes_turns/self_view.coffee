define [
  'game/levels/circle_proximity/self_view'
  'text!./self_view.hbs'
],
(
  CircleProximitySelfView
  tmpl
) ->



  View = CircleProximitySelfView.extend

    # ----------------------------------------------------- Class Extensions
    tmpl: tmpl


    # ----------------------------------------------------- Private Methods



    # ----------------------------------------------------- Consumable API
    # TODO: Implement, so that external objects can calculate the self circle's position
    getSelfCenter: ->
      #@_center or @_calculateSelfCenter()
    getSelfRadius: ->
      #@_radius or @model.get('pxSize') / 2

  View

