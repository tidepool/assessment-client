define [
  'jquery'
  'backbone'
  'core'
],
(
  $
  Backbone
  app
) ->

  _me = 'entities/games'

  Model = Backbone.Model.extend

    LEVELS:
      rank_images: 'ImageRank'
      circle_size_and_proximity: 'CirclesTest'
      reaction_time_disc: 'ReactionTime'


    # ------------------------------------------------------------- Backbone Methods
    urlRoot: "#{window.apiServerUrl}/api/v1/users/-/games"
#    url: '/_data/users/-/games/reaction_time.json'

    initialize: ()  ->
      #@on 'all', (e) -> console.log "#{_me} event: #{e}"
      #@on 'reset', (model) -> console.log model.attributes
      #@on 'sync', (model) -> console.log model.attributes
      #@on 'change', (model) -> console.log model.attributes
      @_levelsSeen = [] # Used to track what the user has and hasn't seen
      @

    # Front End -> Server. This transform is done before PUTing to the server
    toJSON: (options) ->
      _.pick @attributes, 'stage_completed' # The only thing we need to tell the server as we work on the game is the stage completed.

    # Server -> Front End. Translates data we receive from the server
#    parse: (resp) ->
#      # Mix in a result model
#      if resp.result?
#        resp.result = new Result resp.result, {parse:true}
#      resp


    # addUser: (user) ->
    #   attrs = { 'user_id': user.get('id') }
    #   deferred = $.Deferred()
    #   @save attrs,
    #     patch: false
    #     # url: "#{@url()}/#{@get('id')}"
    #   .done (data, textStatus, jqXHR) ->
    #     console.log("Add User Success: #{textStatus}")
    #     deferred.resolve(jqXHR.response)
    #   .fail (jqXHR, textStatus, errorThrown) ->
    #     console.log("Add User Error: #{textStatus}")
    #     deferred.reject(textStatus)

    #   deferred.promise()

    getLatestWithProfile: ->
      deferred = $.Deferred()
      @fetch({ url: "#{@url()}/latest_with_profile" })
        .done (data, textStatus, jqXHR) =>
          console.log('Got the latest game')
          deferred.resolve()
        .fail (jqXHR, textStatus, errorThrown) =>
            deferred.reject()
      deferred.promise()   

#    getResult: ->
#      deferred = $.Deferred()
#      if @get('result')?
#        deferred.resolve("Result already exists")
#      else
#        result = new Result({assessment_id: @get('id')})
#        @set({result: result})
#        if @get('status') is 'results_ready'
#          result = @get('result')
#          result.fetch()
#          .done (data, textStatus, jqXHR) =>
#            console.log("Get Result Success: #{textStatus}")
#            deferred.resolve(jqXHR.response)
#          .fail (jqXHR, textStatus, errorThrown) =>
#            console.log("Get Result Error: #{textStatus}")
#            deferred.reject(textStatus)
#        else
#          result = @get('result')
#          result.calculateResult()
#          .done =>
#            console.log "#{_me}.getResult().result.calculateResult().done()"
#            deferred.resolve()
#          .fail =>
#            console.log "#{_me}.getResult().result.calculateResult().fail()"
#            deferred.reject()
#
#      deferred.promise()


    # ------------------------------------------------------------- Public API
    create: (gameDefinitionId) ->
#      $.post "#{@urlRoot}/#{@attributes.definition_id}"
      if gameDefinitionId
        @save( def_id: gameDefinitionId )
      else
        @save() # Uses the default definition id
      @

    nextStage: ->
      #console.log "#{_me}.nextStage()"
      i = @get('stage_completed')
#      @save( {stage_completed: i + 1}, { wait:true } ) # Wait to change the client until the server confirms
      @save stage_completed: i + 1

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


  Model