define [
  'backbone'
  'Handlebars'
  "text!./steps_remaining.hbs"
],
(
  Backbone
  Handlebars
  tmpl
) ->

  _tmpl = Handlebars.compile tmpl

  View = Backbone.View.extend
    className: 'stepsRemaining'
    initialize: ->
      @
      @listenTo @collection, 'change:isComplete', @render

    render: ->
#      console.log "#{@className} render"
#      console.log
#        stages: @collection.toJSON()
      @$el.html _tmpl
        levels: @collection.toJSON()
      return this

    setComplete: (LevelId) ->
      level = @collection.at LevelId
      level.set('isComplete', true) if level?

  View


