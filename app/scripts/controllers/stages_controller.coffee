define [
  'jquery'
  'backbone'
  'Handlebars'
  'modelsAndCollections/levels'
  'ui_widgets/steps_remaining'
  'stages/reaction_time'
  'stages/image_rank'
  'stages/circles_test'
],
(
  $
  Backbone
  Handlebars
  LevelsCollection
  StepsRemainingView
  ReactionTime
  ImageRank
  CirclesTest
) ->

  _me = 'controllers/stages_controller'
  _stepsRemainingContainer = '#HeaderRegion'
  _views =
    'ReactionTime': 'ReactionTime'
    'ImageRank': 'ImageRank'
    'CirclesTest': 'CirclesTest'

  StagesController = Backbone.View.extend
    initialize: (options) ->
      throw new Error("Needs arguments[0].assessment") unless options?.assessment
      console.log "#{_me} initialized"
      @assessment = options.assessment
      @levels = new LevelsCollection @assessment.get('stages')
      @stepsRemaining = new StepsRemainingView
        collection: @levels
      $(_stepsRemainingContainer).append @stepsRemaining.render().el
      @

    render: (stageId) ->
      @levels.setComplete stageId
      curLevel = @levels.at stageId
      viewClassString = _views[curLevel.get('view_name')]
      ViewClass = eval(viewClassString)
      view = new ViewClass
        model: curLevel
        assessment: @assessment
        stageNo: stageId
      #@$el.html view.render().el
      #$('#content').html view.render().el
      @el = view.render().el
      @

  StagesController
