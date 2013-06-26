define [
  'backbone'
  'core'
],
(
  Backbone
  app
) ->

  _me = 'entities/cur_user_recommendations'

  # A Single Game Level
  Model = Backbone.Model.extend
    urlRoot: "#{app.cfg.apiServer}/api/v1/users/-/recommendations"
    id: 'latest'

  Model

