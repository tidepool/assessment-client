define [
  'backbone'
  'Handlebars'
  'text!./main.hbs'
  './rankable_images'
  'models/user_event'
  'jqueryui/sortable'
  'ui_widgets/proceed'
],
(
  Backbone
  Handlebars
  tmpl
  RankableImages
  UserEvent
  Sortable
  proceed
) ->

  _me = 'game/levels/rank_images'
  _rankingSel= '#RankingArea'
  _unrankedSel = '#UnrankedArea'
  _sortableSel = '.connectedSortable'
  _msgHtml = '<li class="message">Rank from best to worst by clicking or dragging images.</li>'
  _researchModuleName = 'image_rank'
  _USEREVENTS =
    started: "test_started"
    ranked: "image_ranked"
    unranked: "image_rank_cleared"
    dragged: "image_drag_start"
    completed: "test_completed"


  View = Backbone.View.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'rankImages'

    initialize: ->
      @collection = new RankableImages @model.get('image_sequence')
      # Bind the funky callbacks we need for jQuery Sortable
      _.bindAll @, 'onOver', 'onSortStart', 'onSortEnd', 'onUnrankedImageClick', 'onRankedImageClick', 'onProceedClick'
      #@listenTo @collection, 'all', (e) -> console.log "#{_me} event: #{e}"
      @listenTo @collection, 'change:rank', @onRankChange
      @listenToOnce proceed, 'click', @onProceedClick
      @render()
      @_trackStart()

    render: ->
      @$el.html tmpl

      # Add the draggable images
      @collection.each (imageModel) =>
        @$(_unrankedSel).append imageModel.view.render().el

      # Add the blank state message
      @$msg = $(_msgHtml)
      @_checkOnMsg()

      # Initialize the sortable and bind needed events
      @$(_sortableSel).sortable
        #containment: ".#{@.className}"
        placeholder: 'rankableImage placeholder'
        connectWith: _sortableSel
        cancel:  ".#{@$msg.prop('class')}"
        over: @onOver
        start: @onSortStart
        stop: @onSortEnd
      @$(_sortableSel).disableSelection()
      @$(_unrankedSel).on('click', '.rankableImage', @onUnrankedImageClick)
      @$(_rankingSel).on('click', '.rankableImage', @onRankedImageClick)
      @


    # ----------------------------------------------------- Private Methods
    _checkOnMsg: ->
      if @$(_rankingSel).children().length
        @_hideMsg()
      else
        @_showMsg()
    _showMsg: ->
      @$(_rankingSel).append @$msg
    _hideMsg: ->
      @$msg.remove()
    _userTasksFinished: ->
      proceed.show()
    _userTasksUnfinished: ->
      proceed.hide()
    _checkOnRanks: ->
      # For each collection, check if it's ranked or not, and use its index to set the ranking on the data model
      @collection.each (model) ->
        if model.view.$el.parent(_rankingSel).length
          model.set rank: model.view.$el.index() + 1
        else
          model.set rank: model.defaults.rank
      rankedImages = @collection.filter (image) ->
        image.get('rank')
      if rankedImages.length is @collection.length
        @_userTasksFinished()
      else
        @_userTasksUnfinished()


    # ----------------------------------------------------- Event Handlers
    onUnrankedImageClick: (e) ->
      #console.log "#{_me}.onUnrankedImageClick()"
      @$(_rankingSel).append e.currentTarget
      @_checkOnMsg()
      @_checkOnRanks()
    onRankedImageClick: (e) ->
      #console.log "#{_me}.onRankedImageClick()"
      @$(_unrankedSel).append e.currentTarget
      @_checkOnMsg()
      @_checkOnRanks()
    onProceedClick: ->
      @_trackEnd()
      @options.assessment.nextStage()
      proceed.hide()
    onOver: -> @_checkOnMsg()
    onSortStart: (e, ui) ->
      id = $(e.currentTarget).find('img').data('id')
      @_trackDragged id
      # Remove the helper from the original location. This way css labels on :first-child and :last-child will work beautifully
      ui.helper.appendTo('body') # The appendTo option seems broken, but manually removing the helper like this seems to work well
    onSortEnd: (e, ui) ->
      #console.log "#{_me}.onSortEnd"
      @_checkOnRanks()
    onRankChange: (model, value, options) ->
      #console.log "#{_me}.onRankingChange new rank for image #{model.attributes.image_id}: #{model.attributes.rank}"
      if value is -1
        @_trackRankCleared model.attributes.image_id, model.previous('rank')
      else
        @_trackRanked model.attributes.image_id, value


    # ----------------------------------------------------- User Event Tracking
    _trackUserEvent: (newEvent) ->
      eventInfo =
        game_id: @options.assessment.get('id')
        module: _researchModuleName
        stage: @options.stageNo
      userEvent = new UserEvent()
      userEvent.send _.extend(eventInfo, newEvent)
    _trackStart: ->
      @_trackUserEvent
        event_desc: _USEREVENTS.started
        image_sequence: @collection.toJSON()
    _trackRanked: (id, newRank) ->
      @_trackUserEvent
        image_no: id
        rank: newRank
        event_desc: _USEREVENTS.ranked
    _trackRankCleared: (id, oldRank) ->
      @_trackUserEvent
        image_no: id
        rank: oldRank
        event_desc: _USEREVENTS.unranked
    _trackDragged: (id) ->
      @_trackUserEvent
        image_no: id
        event_desc: _USEREVENTS.dragged
    _trackEnd: ->
      @_trackUserEvent
        event_desc: _USEREVENTS.completed

  View


