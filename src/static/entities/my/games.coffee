define [
  'jquery'
  'classes/model'
],
(
  $
  Model
) ->

  Export = Model.extend


    # ------------------------------------------------------------- Backbone Methods
    urlRoot: -> "#{window.apiServerUrl}/api/v1/users/-/games"

    initialize: ->
      # @on 'all', (e) -> console.log "event: #{e}"
      @_levelsSeen = [] # Used to track what the user has and hasn't seen
      @

    # Front End -> Server. This transform is done before PUT or POST to the server
    toJSON: (options) ->
      _.pick @attributes, 'stage_completed', 'def_id' # The only thing we need to tell the server as we work on the game is the stage completed, and when we create the game, the def_id


    # ------------------------------------------------------------- Public API
    getLatestWithProfile: ->
      deferred = $.Deferred()
      @fetch({ url: "#{@url()}/latest_with_profile" })
        .done (data, textStatus, jqXHR) =>
          deferred.resolve()
        .fail (jqXHR, textStatus, errorThrown) =>
            deferred.reject()
      deferred.promise()

    create: (gameDefinitionId) ->
      if gameDefinitionId
        @save( def_id: gameDefinitionId )
      else
        @save() # Uses the default definition id
      @

    nextStage: ->
      i = @get('stage_completed')
#      @save( {stage_completed: i + 1}, { wait:true } ) # Wait to change the client until the server confirms
      @set stage_completed: i + 1

    # See if this is the first time the user has seen this level
    # levelStringId should be a unique string key defining the level type
    setLevelSeen: (levelStringId) ->
      @_levelsSeen.push levelStringId
      @_levelsSeen = _.uniq @_levelsSeen
      @

    isFirstTimeSeeingLevel: (levelStringId) ->
      return null unless levelStringId
      return false if _.contains @_levelsSeen, levelStringId
      return true


  Export