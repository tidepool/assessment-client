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
  _bodySel = '#PerchBody'

  Model = Backbone.Model.extend
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
      $(_defaultParent).append @el
      @model = new Model()
      @listenTo @model, 'change', @render

    render: ->
      console.log "#{_me}.render()"
      @$el.html @tmpl @model.attributes
      @


    # ---------------------------------------------------------------------- Event Handlers
    _onBtn1Click: (e) -> console.log "#{_me}._onBtn1Click()"
    _onBtn2Click: (e) -> console.log "#{_me}._onBtn2Click()"

    _onModalShown: ->
      console.log "#{_me}._onModalShown()"
      @_addChildView()

    _onModalHide: ->
      console.log "#{_me}._onModalHide()"

    _onModalHidden: ->
      console.log "#{_me}._onModalHidden()"
      @_viewCleanup()


    # ---------------------------------------------------------------------- Private Helper Methods
    _showSimpleMsg: (msg) ->
      @_showOptionsObject
        content: "<p>#{msg}</p>"

    _showBackboneView: (options) ->
      @_childView = options.content
      options.content = null
      @_showOptionsObject options

    _showOptionsObject: (options) ->
      @model.set options
      @$el.modal 'show'
      @_bindDomEvents()

    _addChildView: ->
      $(_bodySel).prepend @_childView?.render().el

    _viewCleanup: ->
      @$el
        .off('shown')
        .off('hide')
        .off('hidden')
      if @_childView?
        @_childView.close?()
        @_childView.remove()

    _bindDomEvents: ->
      @$el
        .on('shown', @_onModalShown.bind @)
        .on('hide', @_onModalHide.bind @)
        .on('hidden', @_onModalHidden.bind @)


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