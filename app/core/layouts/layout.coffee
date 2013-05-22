
define [
  'underscore'
  'Backbone'
  'Handlebars'
],
(
  _
  Backbone
  Handlebars
) ->

  _me = 'core/layouts/layout'

  Me = Backbone.View.extend

    # Override these defaults in your inheriting class
    tagName: 'section'
    tmpl: '<div class="content" id="Content"></div>'
    render: -> @$el.html @tmpl

    # Private
    _cleanupChildren: ->
      @_curView?.close?()
      @_curView?.remove()

    # Public
    show: (view) ->
      console.log "#{_me}.render()"
      @_cleanupChildren() # A layout class method
      @_curView = view
      @$('#Content').html @_curView.render().el

    close: ->
      @_cleanupChildren()

  Me

