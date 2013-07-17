

define [
  'backbone'
  'text!./index.hbs'
  './connection'
],
(
  Backbone
  tmpl
  ConnectionView
) ->

  _containerSel = '.connections'

  View = Backbone.View.extend

    className: 'connectionsIndex'

    events:
      'click #ActionActiviateFitbit': 'onClickFitbit'


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @fitbit = new ConnectionView app: @options.app

    render: ->
      @$el.html tmpl
      @$(_containerSel).append @fitbit.render().el
      @


    # ----------------------------------------------------------- Private Helper Methods


    # ----------------------------------------------------------- Event Handlers


  View
