define [
  'classes/model'
  'core'
],
(
  Model
  app
) ->

  Export = Model.extend
    urlRoot: "#{app.cfg.apiServer}/api/v1/users/-/recommendations"
    id: 'latest'

  Export

