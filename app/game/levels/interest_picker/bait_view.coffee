define [
  'backbone'
  'Handlebars'
  'text!./bait_symbol.hbs'
], (
  Backbone
  Handlebars
  tmplSymbol
) ->

  _tmplSymbol = Handlebars.compile tmplSymbol
  _bentoSel = '.bentoBox .content'
  _menuSel = '.menu .content'

  Export = Backbone.View.extend
    className: 'bait'
    events:
      'click': 'onClick'

    # ------------------------------------------------------------- Backbone Methods
    render: ->
      if @model.attributes.type is @model.TYPES.symbol
        @$el.html _tmplSymbol @model.attributes
        @$el.addClass @model.TYPES.symbol
      else
        @$el.text @model.attributes.value
        @$el.addClass @model.TYPES.symbol
      @

    onClick: (e) ->
      if @model.attributes.isPicked
        @$el.appendTo _menuSel
        @model.set
          isPicked: false
          record_time: (new Date()).getTime()
      else
        @$el.appendTo _bentoSel
        @model.set
          isPicked: true
          record_time: (new Date()).getTime()
          @


  # ------------------------------------------------------------- Consumable API


  Export