define [
  'backbone'
  'Handlebars'
  'text!./reaction_time.hbs'
  'dashboard/widgets/base'
], (
  Backbone
  Handlebars
  tmpl
  Widget
) ->

  View = Widget.extend
#    events: 'click': 'onClick'
    render: ->
      @$el.html tmpl
      @

  View


