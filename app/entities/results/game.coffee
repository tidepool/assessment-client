
define [
  'backbone'
  'entities/results/result'
  'core'
  'game/results/reaction_time'
  'game/results/personality'
  'game/results/emotions'
], (
  Backbone
  Result
  app
  ReactionTimeResultView
  PersonalityResultView
  EmotionsResultView
) ->

  _me = 'entities/results/game'
  # Key map of server provided result types with the view that should display it
  _resultViews =
    ReactionTimeResult: ReactionTimeResultView
    PersonalityResult: PersonalityResultView
    Holland6Result: null # null means intentionally don't show a view of this result type
    Big5Result: null # null means intentionally don't show a view of this result type
    EmoResult: EmotionsResultView


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
        else if Klass is null
#          console.log "`#{model.attributes.type}` configured to not show results, and that's ok."
        else
          console.error "No view class has been built and configured for result type `#{model.attributes.type}`"


    # ------------------------------------------------------------- Callbacks
    onSync: (collection, rawData) ->
#      console.log "#{_me}.onSync()"
#      console.log
#        collection:collection.toJSON()
#        rawData: rawData
      if rawData.status?.state is Result.STATES.pending
        console.error "Data synced but it doesn't look like a result set"
      else
        @_makeViewsForModels()


    onErr: -> console.error "#{_me}: error"

  Collection

