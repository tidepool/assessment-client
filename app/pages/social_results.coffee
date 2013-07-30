define [
  'backbone'
  'Handlebars'
  'core'
  'text!./social_results.hbs'
], (
  Backbone
  Handlebars
  app
  tmpl
) ->

  _tmpl = Handlebars.compile tmpl



  Me = Backbone.View.extend
    title: 'Social Survey Results'
    className: 'socialResultsPage'
    initialize: ->
      console.error "Need game_id" unless @options.params.game_id
      console.log "Showing social results associated with game `#{@options.params.game_id}`"
    render: ->
      @$el.html _tmpl @options.params
      @


  Me

