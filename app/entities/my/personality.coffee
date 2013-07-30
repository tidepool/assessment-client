
define [
  'classes/model'
  'core'
  'markdown'
], (
  Model
  app
  markdown
) ->


  Personality = Model.extend

    url: "#{app.cfg.apiServer}/api/v1/users/-/personality"

    initialize: ->
      @on 'sync', @onSync
      @on 'error', @onErr

    parse: (resp, options) ->
      resp = @dewrap resp # dewrap is from the extended/parent object
      htmlBullets = []
      # Parse markdown in the one_liner
      if resp?.profile_description?.one_liner?
        resp.profile_description.one_liner = markdown.toHTML resp.profile_description.one_liner
      # Parse markdown in html bullets
      if resp?.profile_description?.bullet_description?
        for bullet in resp.profile_description.bullet_description
          htmlBullets.push markdown.toHTML bullet
        resp.profile_description.bullet_description = htmlBullets
      resp

    onSync: (model) ->
      #console.log model.attributes
      # Consider an empty model an error
      # TODO: have server return 404 if the personality is empty
    onErr: -> console.error "#{_me}: Trouble getting the User Personality Model"

  Personality
