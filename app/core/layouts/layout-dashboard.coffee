
define [
  'underscore'
  'backbone'
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

  _me = 'core/layouts/layout-dashboard'

  Me = Layout.extend
    className: 'dashboardLayout'

    initialize: ->
      Me.__super__.initialize.call(this)
      @render()

    render: ->
      @$el.html @tmpl()
      Me.__super__.resetHeader.call(this)
      @$('#HeaderRegion')
        .append(userMenu.el)
      @

  Me

