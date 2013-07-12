
define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./action_items.hbs'
], (
  _
  Backbone
  Handlebars
  tmpl
) ->

  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: 'actionItems'

    # -------------------------------------------------------- Backbone Methods
    initialize: ->
      # A new dependency chain. Since the recommendation needs app.cfg, this is otherwise circular
      require ['entities/cur_user_recommendations'], (NextAction) =>
        @model = new NextAction()
        @listenTo @model, 'sync', @onSync
        @model.fetch()

    render: ->
      @$el.html _tmpl @model.attributes
      @

    onSync: (model) ->
#      console.log model:model
      @render()


    # -------------------------------------------------------- Private Methods



  View


