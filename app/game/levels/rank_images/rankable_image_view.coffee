define [
  'backbone'
  'Handlebars'
  'text!./rankable_image_view.hbs'
],
(
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'game/levels/rank_images/rankable_image_view'
  _parentSel = '.rankImages'
  _targetSel = '.dropTarget'

  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    tmpl: Handlebars.compile tmpl
    className: 'rankableImage'
    tagName: 'li'
    attributes: tabindex: 2 # Makes them focusable
    initialize: ->
    render: ->
      @$el.html @tmpl @model.attributes
      @


    # ----------------------------------------------------- Private Methods


    # ----------------------------------------------------- Event Callbacks



  View




