
define [
  'underscore'
  'Backbone'
  'Handlebars'
  './layout'
  'ui_widgets/user_menu'
],
(
  _
  Backbone
  Handlebars
  Layout
  userMenu
) ->

  _me = 'core/layouts/layout-game'

  Me = Layout.extend
    className: 'gameLayout'

    initialize: ->
      console.log "#{_me}.initialize()"
      Me.__super__.initialize.call(this)
      @render()

    render: ->
      console.log "#{_me}.render()"
      @$el.html @tmpl()
      Me.__super__.resetHeader.call(this)
      @$('#HeaderRegion')
        .append(userMenu.el)

  Me

