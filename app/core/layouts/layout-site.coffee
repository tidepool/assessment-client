
define [
  'underscore'
  'Backbone'
  'Handlebars'
  './layout'
  'text!ui_widgets/main_nav.hbs'
  'ui_widgets/user_menu'
],
(
  _
  Backbone
  Handlebars
  Layout
  markupNav
  userMenu
) ->

  _me = 'core/layouts/layout-site'

  Me = Layout.extend
    className: 'siteLayout'
    initialize: ->
      #console.log "#{_me}.initialize()"
      Me.__super__.initialize.call(this)
      @render()

    render: ->
      #console.log "#{_me}.render()"
      @$el.html @tmpl()
      Me.__super__.resetHeader.call(this)
      userMenu.delegateEvents() # This tells Backbone to set up the view's events again
      @$('#HeaderRegion')
        .append(markupNav)
        .append(userMenu.el)
      @

  Me


