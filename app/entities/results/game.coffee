
define [
  'backbone'
  'entities/results/result'
  'core'
  'game/results/reaction_time'
], (
  Backbone
  Result
  app
  ReactionTimeResultView
) ->

  _me = 'entities/results/game'
  # Key map of server provided result types with the view that should display it
  _resultViews =
    ReactionTimeResult: ReactionTimeResultView
    PersonalityResult: null
    Holland6Result: null
    Big5Result: null


  Collection = Backbone.Collection.extend

    url: -> "#{app.cfg.apiServer}/api/v1/users/-/games/#{@game_id}/results"

    model: Result

    initialize: (options) ->
      throw new Error "Need game_id" unless options.game_id?
      @game_id = options.game_id
      @on 'error', @onErr
      @on 'sync', @onSync


    # ------------------------------------------------------------- Private Methods
    _makeViewsForModels: ->
      @each (model) ->
        # Instantiate a view class, if the model has one
        Klass = _resultViews[model.attributes.type]
        if Klass?
          model.view = new Klass model:model
        else
          console.error "No view class configured for result type `#{model.attributes.type}`"


    # ------------------------------------------------------------- Callbacks
    onSync: (collection, rawData) ->
      console.log "#{_me}.onSync()"
      console.log collection:collection.toJSON()
      @_makeViewsForModels()


    onErr: -> console.error "#{_me}: error"

  Collection

