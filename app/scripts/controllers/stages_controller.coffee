define [
  'jquery'
  'Backbone'
  'Handlebars'
  'modelsAndCollections/levels'
  'uiWidgets/steps_remaining'
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

  _stepsRemainingContainer = '#StepsRemainingHolder'

  StagesController = ->
    views:
      'ReactionTime': 'ReactionTime'
      'ImageRank': 'ImageRank'
      'CirclesTest': 'CirclesTest'

    initialize: (options) ->
      @currentStageNo = options.currentStageNo
      @assessment = options.assessment
      @levels = new LevelsCollection @assessment.get('stages')
      @levels.setComplete @currentStageNo

      @stepsRemaining = new StepsRemainingView
        collection: @levels
      $(_stepsRemainingContainer).html @stepsRemaining.render().el

    render: ->
      #StepsRemainingView.setStageCompleted(@currentStageNo - 1)

      curLevel = @levels.at(@currentStageNo)
      viewClassString = @views[curLevel.get('view_name')]
      viewClass = eval(viewClassString)
      view = new viewClass({model: curLevel, assessment: @assessment, stageNo: @currentStageNo})
      $('#content').html(view.render().el)
      @

  StagesController




