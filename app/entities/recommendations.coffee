define [
  'backbone'
  'core'
],
(
  Backbone
  app
) ->

  _me = 'entities/recommendations'

  # A Single Game Level
  Model = Backbone.Model.extend
    urlRoot: "#{app.cfg.apiServer}/api/v1/users/-/recommendations"
    latest: ->
      @id = 'latest'
      @fetch()

  Model

