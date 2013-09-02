define [
  'text!./snoozer.hbs'
  'dashboard/widgets/base'
], (
  tmpl
  Widget
) ->

  Widget.extend
    tmpl: tmpl
    className: 'teaser-snoozer'

