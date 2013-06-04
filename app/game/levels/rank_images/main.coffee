define [
  'backbone'
  'Handlebars'
  'text!./main.hbs'
  './rankable_images'
  './drop_target_view'
  'jqueryui/sortable'
],
(
  Backbone
  Handlebars
  tmpl
  RankableImages
  DropTargetView
  JqUiSortable
) ->

  _me = 'game/levels/rank_images/main'
  _testImg =
    name: 'A Test Rankable Image'
    imageUrl: "images/devtest_images/F1b.jpg"
  _testImg2 =
    name: 'A Test Rankable Image'
    imageUrl: "images/devtest_images/7a.jpg"
  _testData = [
    _testImg
    _testImg2
    _testImg
    _testImg2
    _testImg
  ]
  _targetSel = '.dropTarget'
  _targetContainer = '#DropTargets'
  _rankingContainer = '#RankedImages'
  _imageContainer = '#RankableImages'

  View = Backbone.View.extend

    className: 'rankImages'

    # ----------------------------------------------------- Backbone Extensions
    initialize: ->
      @collection = new RankableImages @model.get('image_sequence')
      #@listenTo @collection, 'all', (e) -> console.log "#{_me} event: #{e}"
      @render()

    render: ->
      @$el.html tmpl

      # Add all the drop targets
      for model, i in @collection
        view = new DropTargetView rank: i + 1
        @$(_targetContainer).append view.render().el

      # Add the draggable images
      @collection.each (imageModel) =>
        @$(_imageContainer).append imageModel.view.render().el

      @$('.connectedSortable').sortable
        placeholder: 'dropTarget onTarget'
        connectWith: '.connectedSortable'

      @


    # ----------------------------------------------------- Private Methods


    # ----------------------------------------------------- Event Handlers
    onDrop: (event, ui) ->
      console.log "#{_me}.onDrop()"



  View


