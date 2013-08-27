
define [
  'backbone'
  'dashboard/widgets/lister'
], (
  Backbone
  Lister
) ->

  View = Lister.extend
    className: 'coolTones'
    render: ->
      @renderList
        title: 'Skills to Work On'
        icon: 'icon-ok' # optional, override the bullet icon
        list: @model.attributes.skills
      @

  View.dependsOn = 'entities/my/career'
  View





