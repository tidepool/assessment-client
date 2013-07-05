define [
  'backbone'
  'Handlebars'
  'text!./reaction_results.hbs'
  'dashboard/widgets/base'
  'game/results/reaction_time'
], (
  Backbone
  Handlebars
  tmpl
  Widget
  ReactionResultView
) ->

  _tmpl = Handlebars.compile tmpl
  _contentSel = '.contents'

  View = Widget.extend
    className: 'coolTones reaction-results'
    render: ->

      @$el.html _tmpl
      # put the chart in the widget
      latestResult = @collection.at @collection.length - 1
      resultView = new ReactionResultView model:latestResult
      @$(_contentSel).html resultView.render().el
      @


  View.dependsOn = 'entities/results/results'
  View.fetchOptions = data: type: 'ReactionTimeResult'
  View


