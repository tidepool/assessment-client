define [
  'jquery',
  'Backbone',
  'Handlebars',
  'components/progress_bar_view',
  'stages/reaction_time',
  'stages/image_rank',
  'stages/circles_test',
  'models/stage',
  'models/assessment'], ($, Backbone, Handlebars, ProgressBarView, ReactionTime, ImageRank, CirclesTest) ->
  StagesController = ->
    views:
      'ReactionTime': 'ReactionTime'
      'ImageRank': 'ImageRank'
      'CirclesTest': 'CirclesTest'

    initialize: (options) ->
      @currentStageNo = options.currentStageNo
      @assessment = options.assessment
      @stages = new Backbone.Collection(@assessment.get('stages'))

    render: ->
      @progressBarView = new ProgressBarView({numOfStages: @stages.length})
      @progressBarView.setStageCompleted(@currentStageNo - 1)
      $('#progressbarcontainer').html(@progressBarView.render().el)

      stage = @stages.at(@currentStageNo)
      viewClassString = @views[stage.get('view_name')]
      viewClass = eval(viewClassString)
      view = new viewClass({model: stage, assessment: @assessment, stageNo: @currentStageNo})
      $('#content').html(view.render().el)
      this

    # stringToFunction: (str) ->
    #   namespace = str.split(".")
    #   func = (window || this)
    #   for newFunc in namespace
    #     func = func[newFunc]
    #   if (typeof func isnt "function")
    #     throw new Error("function not found")
    #   func

  StagesController