

define [
  'backbone'
  'Handlebars'
  'text!./connection_view.hbs'
],
(
  Backbone
  Handlebars
  tmpl
) ->


  Handlebars.registerHelper 'prettyDate', (dateStr) ->
    date = new Date dateStr
    date.toLocaleDateString()
  Handlebars.registerHelper 'prettyTime', (dateStr) ->
    date = new Date dateStr
    date.toLocaleTimeString()
  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: 'connection clearfix'
    tagName: 'li'
    events: 'click .sync': 'onClickSync'

    # ----------------------------------------------------------- Backbone Methods
    initialize: -> @listenTo @model, 'change', @render

    render: ->
      @$el.html _tmpl @model.attributes
      @

    onClickSync: -> @model.syncConnection()




  View
