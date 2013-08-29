

define [
  'backbone'
  'text!./connection_list.hbs'
  'entities/my/connections'
  './connection_view'
],
(
  Backbone
  tmpl
  MyConnections
  ConnectionView
) ->

  _containerSel = '.connections'

  View = Backbone.View.extend

    className: 'connectionList'

    events:
      'click #ActionActiviateFitbit': 'onClickFitbit'


    # ----------------------------------------------------------- Backbone Methods
    initialize: ->
      @collection = new MyConnections app: @options.app
      @listenTo @collection, 'sync', @onSync
      @collection.fetch()

    render: ->
      @$el.html tmpl
      @


    # ----------------------------------------------------------- Private Helper Methods
    _renderList: ->
#      console.log collection:@collection.toJSON()
      @collection.each (model) ->
        model.view = new ConnectionView model:model
        @$(_containerSel).append model.view.render().el


    # ----------------------------------------------------------- Event Handlers
    onSync: ->
      @_renderList()


  View
