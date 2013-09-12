
define [
  'backbone'
  'dashboard/widgets/base'
  'text!./steps_and_emotions.hbs'
#  'charts/steps_and_emotions'
], (
  Backbone
  Widget
  tmpl
#  StepsAndEmotionsView
) ->

  _widgetSel = '.widget'

  View = Widget.extend
    className: 'doubleWide stepsAndEmotions'

    render: ->
      @emotions = @options.emotions
      console.log
        collection:@collection.toJSON()
        emotions:@emotions.toJSON()
      if @emotions.length
        @renderChart()
      else
        @remove()

      # get the emotions history
      # when we have that, render the graph that combines steps and emotions
#      @$el.html tmpl
#      @$(_widgetSel).append view.render().el
      @

    renderChart: -> #console.log 'renderChart'




  View.dependsOn =
    collection:
      klass: 'entities/my/activities'
    emotions:
      klass: 'entities/results/results'
      fetchOptions: data: type: 'EmoResult'

  View


