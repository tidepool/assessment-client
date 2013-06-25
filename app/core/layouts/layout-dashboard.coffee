
define [
  'underscore'
  'backbone'
  'Handlebars'
  './layout'
  'ui_widgets/user_menu'
  'text!dashboard/dash_picker.hbs'
],
(
  _
  Backbone
  Handlebars
  Layout
  userMenu
  tmplDashPicker
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
      userMenu.delegateEvents() # This tells Backbone to set up the view's events again
      @$('#HeaderRegion')
        .append(userMenu.el)
      @
      @$('.content').before tmplDashPicker

  Me

