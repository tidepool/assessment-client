define [
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'text!./main.hbs'
  './rankable_images'
  'jqueryui/sortable'
],
(
  Backbone
  Handlebars
  Level
  tmpl
  RankableImages
  xJqUISortable
) ->

  _me = 'game/levels/rank_images'
  _rankingSel= '#RankingArea'
  _unrankedSel = '#UnrankedArea'
  _rankableImageSel = '.rankableImage'
  _proceedSel = '.proceed'
  _sortableSel = '.connectedSortable'
  _msgHtml = '<li class="message">Rank from favorite to least favorite by clicking or dragging images.</li>'
  _EVENTS =
    ranked: "image_ranked"
    unranked: "image_rank_cleared"


  View = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'rankImages'

    start: ->
      @collection = new RankableImages @model.get('image_sequence')
      @options.instructions.set text: @model.get('instructions')
      # Bind the funky callbacks we need for jQuery Sortable
      _.bindAll @, 'onOver', 'onSortStart', 'onSortEnd', 'onUnrankedImageClick', 'onRankedImageClick', 'onUnrankedImageKeypress', 'onRankedImageKeypress'
      #@listenTo @collection, 'all', (e) -> console.log "#{_me} event: #{e}"
      @listenTo @collection, 'change:rank', @onRankChange
      @track Level.EVENTS.start, data:@collection.toJSON()


    render: ->
      @$el.html tmpl

      require ['jquiTouchPunch'], => # This kludge is to support touch on the jqui draggable element. TODO: drag lib with native touch support
        # Add the draggable images
        @collection.each (imageModel) =>
          @$(_unrankedSel).append imageModel.view.render().el
        # Add the blank state message
        @$msg = $(_msgHtml)
        @_checkOnMsg()
        # Initialize the sortable and bind needed events
        @$(_sortableSel).sortable
          containment: ".#{@className}"
          placeholder: 'rankableImage placeholder'
          connectWith: _sortableSel
          cancel:  ".#{@$msg.prop('class')}"
          over:  @onOver
          start: @onSortStart
          stop:  @onSortEnd
        @$(_sortableSel).disableSelection()
        # Keyboard support
        @$(_unrankedSel).on 'keypress', '.rankableImage', @onUnrankedImageKeypress
        @$(_rankingSel).on 'keypress', '.rankableImage',    @onRankedImageKeypress
        # Click to rank, except Gecko which has problems
        # http://stackoverflow.com/questions/947195/jquery-ui-sortable-how-can-i-cancel-the-click-event-on-an-item-thats-dragged
        unless navigator.userAgent.toLowerCase().indexOf('firefox') > -1
          @$(_unrankedSel).on 'click', '.rankableImage',  @onUnrankedImageClick
          @$(_rankingSel).on  'click', '.rankableImage',    @onRankedImageClick

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

    _checkOnRanks: ->
      # For each collection, check if it's ranked or not, and use its index to set the ranking on the data model
      @collection.each (model) ->
        if model.view.$el.parent(_rankingSel).length
          model.set rank: model.view.$el.index()
        else
          model.set rank: model.defaults.rank
      @_buildRankArrayForServer()
      rankedImages = @collection.filter (image) ->
        rank = image.attributes.rank
        return true if rank or rank is 0
      if rankedImages.length is @collection.length
        @readyToProceed()
      else
        @notReadyToProceed()

    _buildRankArrayForServer: -> @summaryData = final_rank: @collection.pluck 'rank'


    # ----------------------------------------------------- Event Handlers
    onUnrankedImageKeypress: (e) ->
      return unless e.charCode or e.which is 32 # Only spacebar
      @onUnrankedImageClick e
      $firstImg = @$(_unrankedSel).find(_rankableImageSel).first() # Optimizing for speed so that we power users and testers can complete the assessment superfast
      if $firstImg
        $firstImg.focus()

    onRankedImageKeypress: (e) ->
      return unless e.charCode or e.which is 32 # Only spacebar
      @onRankedImageClick e

    onUnrankedImageClick: (e) ->
#      console.log "#{_me}.onUnrankedImageClick()"
      @$(_rankingSel).append e.currentTarget
      @_checkOnMsg()
      @_checkOnRanks()

    onRankedImageClick: (e) ->
#      console.log "#{_me}.onRankedImageClick()"
      @$(_unrankedSel).append e.currentTarget
      @_checkOnMsg()
      @_checkOnRanks()

    onOver: -> @_checkOnMsg()

    onSortStart: (e, ui) ->
      id = $(e.currentTarget).find('img').data('id')
      @_trackDragged id

    onSortEnd: (e, ui) ->
#      console.log "#{_me}.onSortEnd"
      @_checkOnRanks()

    onRankChange: (model, value, options) ->
      #console.log "#{_me}.onRankingChange new rank for image #{model.attributes.image_id}: #{model.attributes.rank}"
      if value is null
        @_trackRankCleared model.attributes.image_id, model.previous('rank')
      else
        @_trackRanked model.attributes.image_id, value


    # ----------------------------------------------------- User Event Tracking
    _trackRanked: (id, newRank) ->
      @track _EVENTS.ranked,
        image_no: id
        rank: newRank

    _trackRankCleared: (id, oldRank) ->
      @track _EVENTS.unranked,
        image_no: id
        prev_rank: oldRank

    _trackDragged: (id) ->
      @track Level.EVENTS.moveStart,
        image_no: id




  View


