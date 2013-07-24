
define [
  'backbone'
  'dashboard/widgets/lister'
], (
  Backbone
  Lister
) ->

  _defaults =


  View = Lister.extend
    className: 'coolTones'
    render: ->
      @renderList
        title: 'Tools of the Trade'
        list: @model.attributes.tools
      @

  View.dependsOn = 'entities/my/career'
  View





