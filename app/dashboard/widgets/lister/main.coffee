
define [
  'backbone'
  'Handlebars'
  'text!./lister.hbs'
  'dashboard/widgets/base'
], (
  Backbone
  Handlebars
  tmpl
  Widget
) ->

  _tmpl = Handlebars.compile tmpl

  View = Widget.extend
    tagName: 'section'
    renderList: (data) ->
      console.error "Need data.list and data.title" unless data.list and data.title
      @$el.html _tmpl data
      return this

  View





