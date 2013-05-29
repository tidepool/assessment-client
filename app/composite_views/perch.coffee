define [
  'jquery'
  'backbone'
  'Handlebars'
  "text!./perch.hbs"
],
(
  $
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'composite_views/perch'
  _defaultParent = 'body'
  _contentSel = '#PerchBody'

  PerchModel = Backbone.Model.extend
    defaults:
      title: ''
      content: 'This is the default message.'
      btn1:
        text: "Ok"
        className: "btn-block btn-inverse"

  Me = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    tagName: 'aside'
    className: 'perch modal small hide fade'
    events:
      'click #PerchBtn1': '_onBtn1Click'


    # ---------------------------------------------------------------------- Backbone Methods
    initialize: ->
      @model = new PerchModel()
      @render()
      $(_defaultParent).append @el
      @listenTo @model, 'change', @render

    render: ->
      #console.log "#{_me}.render()"
      @$el.html @tmpl @model.attributes
      @


    # ---------------------------------------------------------------------- Event Handlers
    _onBtn1Click: (e) -> console.log "#{_me}._onBtn1Click()"
    _onBtn2Click: (e) -> console.log "#{_me}._onBtn2Click()"

    _onModalHidden: ->
      #console.log "#{_me}._onModalHidden()"
      @_viewCleanup()


    # ---------------------------------------------------------------------- Private Helper Methods
    _showSimpleMsg: (msg) ->
      @_showOptionsObject
        title: null
        content: "<p>#{msg}</p>"

    _showBackboneView: (options) ->
      @_childView = options.content
      options.content = null
      options.title = options.title || null # blank out the title if one wasn't set
      @_showOptionsObject options
      @_addChildView()

    _showOptionsObject: (options) ->
      @model.set options
      @_bindDomEvents()
      @$el.modal 'show'

    _addChildView: ->
      $(_contentSel).prepend @_childView?.render().el

    _viewCleanup: ->
      @$el.off('hidden')
      if @_childView?
        @_childView.close?()
        @_childView.remove()

    _bindDomEvents: ->
      @$el.on 'hidden', _.bind(@_onModalHidden, @)


    # ---------------------------------------------------------------------- Public API
    show: (options) ->
      if typeof options == 'string'
        @_showSimpleMsg options
      else if options?.content instanceof Backbone.View
        @_showBackboneView options
      else
        @_showOptionsObject options

    hide: ->
      @$el.modal('hide')


  new Me()