define [
  'backbone'
  'Handlebars'
  'text!./circle.hbs'
],
(
  Backbone
  Handlebars
  circleTmpl
) ->

  _me = 'game/levels/circle_proximity/circle_view'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    circleTmpl: Handlebars.compile circleTmpl
    className: 'circle'

    # ----------------------------------------------------- Private Methods


    # ----------------------------------------------------- Event Callbacks



  View




