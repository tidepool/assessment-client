define [
  'backbone'
  'Handlebars'
  'text!./game_results.hbs'
  'text!./game_results-rt.hbs'
  'text!./game_results-emo.hbs'
  'text!./game_results-friend_teaser.hbs'
  'text!./game_results-friend_teaser_email.hbs'
  'entities/results/game'
  'entities/results/results'
  'game/results/reaction_time_history'
  'game/results/emotions_history'
  'game/results/emotions_overview'
  'ui_widgets/psst'
  'core'
  'ui_widgets/guest_signup'
], (
  Backbone
  Handlebars
  tmpl
  rtTmpl
  emoTmpl
  friendTeaserTmpl
  friendTeaserEmail
  GameResults
  Results
  ReactionTimeHistoryView
  EmotionsHistoryView
  EmotionsOverview
  psst
  app
  GuestSignup
) ->

  _contentSel = '#ResultsDisplay'
  _ctaSel = '#CallToAction'
  TYPES =
    pers: 'PersonalityResult'
    rt: 'ReactionTimeResult'
    emo: 'EmoResult'
  TMPLS =
    ReactionTimeResult: rtTmpl
    EmoResult: emoTmpl

  _friendTeaserTmpl = Handlebars.compile friendTeaserTmpl
  _friendTeaserEmail = Handlebars.compile friendTeaserEmail



  Me = Backbone.View.extend
    title: 'Results'
    className: 'gameResultsPage'
    events:
      'click .friendSurvey': 'onClickFriendSurvey'
      'click .surveyPreview': 'onClickSurveyPreview'

    initialize: ->
      throw new Error "Need game_id" unless @options.params?.game_id?
      @collection = new GameResults
        game_id: @options.params.game_id
      @listenTo @collection, 'sync', @onSync
      @listenTo @collection, 'error', @onError
      @collection.fetch()

    render: ->
      @$el.html tmpl
      # If they're a guest, show the guest conversion widget
      if app.user.isGuest()
        guestSignup = new GuestSignup()
        @$(_ctaSel).html guestSignup.render().el
      @


    # -------------------------------------------------------------------- Private Methods
    _renderResults: ->
      @$(_contentSel).empty()
      if @_hasType @collection, TYPES.rt
        @_renderAsType TYPES.rt
      else if @_hasType @collection, TYPES.emo
        @_renderAsType TYPES.emo
      else if @_hasType @collection, TYPES.pers
        @_renderAsType TYPES.pers
      else
        @_renderGeneric()
      @

    _hasType: (collection, type) ->
      collection.find (item) -> item.attributes.type is type


    # -------------------------------------------------------------------- Special Behavior for Specific Results pages
    _renderGeneric: ->
      @collection.each (model) ->
        @$(_contentSel).append model.view?.render().el

    # Render special additions and other changes based on differences between the result types
    _renderAsType: (type) ->
      $('body').addClass "#{@className}-#{type}"
      @$el.html TMPLS[type] if TMPLS[type]?
#      console.log
#        type: type
#        tmpl: TMPLS[type]
      # Add all the result views we've recieved
      @collection.each (model) ->
        @$(_contentSel).append model.view?.render().el
      # Add special behaviors based on the type
      switch type
        when TYPES.rt
          @_appendReactionTimeHistory()
        when TYPES.emo
          @_appendEmotionCharts()
        when TYPES.pers
          personalityModel = @collection.find (m) -> m.attributes.type is TYPES.pers
          stringId = personalityModel.attributes.name.split(' ').join('-')
          teaserData =
            user_id: app.user.id
            game_id: @collection.game_id
            origin: window.location.protocol + '//' + window.location.hostname

          @$(_ctaSel).append _friendTeaserTmpl _.extend teaserData,
            emailSubject: encodeURIComponent 'Request for Help'
            emailBody: encodeURIComponent _friendTeaserEmail teaserData

#          console.log
#            coll: @collection.toJSON()
#            pers: personalityModel
#            stringId: stringId
          $('body').addClass "#{@className}-#{stringId}"
        else
          console.warn "Unknown type: #{type}"

    _appendReactionTimeHistory: ->
      rtResults = new Results()
      history = new ReactionTimeHistoryView collection: rtResults
      history.collection.fetch data: type:TYPES.rt
      @$(_contentSel).append history.render().el

    _appendEmotionCharts: ->
      emoResults = new Results()
      history = new EmotionsHistoryView collection: emoResults
      overview = new EmotionsOverview collection: emoResults
      history.collection.fetch data: type:TYPES.emo
      @$(_contentSel).append history.render().el
      @$(_contentSel).prepend overview.render().el


    # -------------------------------------------------------------------- Event Callbacks
    onSync: (collection, data) ->
      if data?.status?.state is Results.STATES.pending
        @_renderResults()
        psst
          sel: _contentSel
          title: "Results Are Pending"
          msg: "Sorry, but for some reason results haven't yet been calculated for game #{collection.game_id}"
          type: psst.TYPES.error
      else if collection.length
        @_renderResults()
      else
        @$(_contentSel).empty()
        psst
          sel: _contentSel
          title: "No Results Found"
          msg: "Sorry, but we didn't find any results for game #{collection.game_id}"
          type: psst.TYPES.error

    onError: (collection, xhr) ->
      @$(_contentSel).empty()
      psst
        sel: _contentSel
        title: "Error Getting Results"
        msg: xhr.responseJSON?.status.message || xhr.statusText
        type: psst.TYPES.error

    onClickFriendSurvey: ->  app.analytics.trackKeyMetric 'Friend Survey', 'Clicked Email Link'
    onClickSurveyPreview: -> app.analytics.trackKeyMetric 'Friend Survey', 'Clicked Survey Preview'


  Me

