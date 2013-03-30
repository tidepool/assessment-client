define [
  'jquery',
  'Backbone',
  'Handlebars',
  'components/progress_bar_view',
  'stages/reaction_time',
  'stages/image_rank',
  'stages/circles_test',
  "text!./stages_view.hbs",
  'models/stage',
  'models/assessment',
  'models/session'], ($, Backbone, Handlebars, ProgressBarView, ReactionTime, ImageRank, CirclesTest, tempfile) ->
  StagesView = Backbone.View.extend
    views:
      'ReactionTime': 'ReactionTime'
      'ImageRank': 'ImageRank'
      'CirclesTest': 'CirclesTest'

    initialize: (options) ->
      @currentStageNo = options.currentStageNo
      @stages = new Backbone.Collection(@model.get('stages'))

    render: ->
      @progressBarView = new ProgressBarView({numOfStages: @stages.length})
      @progressBarView.setStageCompleted(@currentStageNo - 1)
      $('#progressbarcontainer').html(@progressBarView.render().el)

      stage = @stages.at(@currentStageNo)
      viewClassString = @views[stage.get('view_name')]
      viewClass = eval(viewClassString)
      # viewClass = @stringToFunction(@views[stage.get('view_name')])
      view = new viewClass({model: stage, assessment: @model, stageNo: @currentStageNo})
      $('#content').html(view.render().el)
      this

    stringToFunction: (str) ->
      namespace = str.split(".")
      func = (window || this)
      for newFunc in namespace
        func = func[newFunc]
      if (typeof func isnt "function")
        throw new Error("function not found")
      func

  StagesView