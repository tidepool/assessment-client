define [
  'backbone'
  'Handlebars'
  'core'
  'text!./social_results.hbs'
  'text!./social_results-not_enough.hbs'
  'entities/friend_survey'
  'charts/polar_area'
], (
  Backbone
  Handlebars
  app
  tmpl
  tmplNotEnough
  FriendResults
  Chart
) ->

  _tmpl = Handlebars.compile tmpl
  _tmplNotEnough = Handlebars.compile tmplNotEnough

  _contentSel = '.contents'
  _selfContentSel = '.contentSelf'
  _socialContentSel = '.contentSocial'

  Me = Backbone.View.extend
    title: 'Social Survey Results'
    className: 'socialResultsPage'
    initialize: ->
      console.error "Need game_id" unless @options.params.game_id
      @model = new FriendResults game_id:@options.params.game_id
      @listenTo @model, 'sync', @onSync
      @listenTo @model, 'error', @onErr
      @model.fetch()

    render: ->
      @$el.html _tmpl @options.params
      @

    renderContent: ->

    onSync: ->
      @chartSelf = new Chart
        data:
          name: "Self-Reported"
          chartValues: @model.attributes.my_results
          width: 350
          height: 300
          options: animation: false
      @chartSocial = new Chart
        data:
          name: "Social Personality"
          chartValues: @model.attributes.others_results
          width: 350
          height: 300
      @$(_contentSel).remove()
      @$(_selfContentSel).append @chartSelf.render().el
      @$(_socialContentSel).append @chartSocial.render().el

    onErr: ->
      @$el.html _tmplNotEnough
        game_id: @options.params.game_id
        origin: window.location.protocol + '//' + window.location.hostname + window.location.hash


  Me

