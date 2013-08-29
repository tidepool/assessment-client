
define [
  'underscore'
  'backbone'
  'Handlebars'
  './layout'
  'ui_widgets/user_menu'
  'dashboard/action_items'
  'text!dashboard/dash_picker.hbs'
],
(
  _
  Backbone
  Handlebars
  Layout
  userMenu
  ActionItems
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

      # Add dashboard-specific content
      ai = new ActionItems app:@options.app
      @$('.content').before ai.el
      @$('.content').before tmplDashPicker

  Me

