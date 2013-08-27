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
  _defaultClassnames = 'perch modal'
  _contentSel = '#PerchBody'

  PerchModel = Backbone.Model.extend
    defaults:
      title: ''
      content: 'This is the default message.'
      className: null
      onClose: -> #console.log "#{_me}.onClose"
      btn1Text: "Ok"
      btn1ClassName: "btn-large btn-primary"
      btn1Callback: -> #console.log "#{_me}.btn1.callback"
      mustUseButton: false

  Me = Backbone.View.extend
    tmpl: Handlebars.compile tmpl
    tagName: 'aside'
    className: 'perch modal hide fade'
    events:
      'click #PerchBtn1': '_onBtn1Click'


    # ---------------------------------------------------------------------- Backbone Methods
    initialize: ->
      $(_defaultParent).append @el

    render: ->
      @$el.html @tmpl @model.attributes
      @


    # ---------------------------------------------------------------------- Event Handlers
    _onBtn1Click: (e) ->
      @model.attributes.btn1Callback?()
      @hide()
    _onBtn2Click: (e) -> console.log "#{_me}._onBtn2Click()"

    _onModalHidden: ->
      #console.log "#{_me}._onModalHidden()"
      @model.attributes.onClose?()
      @_viewCleanup()


    # ---------------------------------------------------------------------- Private Helper Methods
    _showSimpleMsg: (msg) ->
      @_showOptionsObject
        msg: msg

    _showBackboneView: (options) ->
      @_childView = options.content
      options.content = null
      options.title = options.title || null # blank out the title if one wasn't set
      @_showOptionsObject options
      @_addChildView()

    _showOptionsObject: (options) ->
      if options.msg
        options.content = "<p>#{options.msg}</p>"
      @model.set options
      @_bindDomEvents()
      dropStyle = if options.mustUseButton then 'static' else true
      @$el.modal
        backdrop: dropStyle

    _addChildView: ->
      $(_contentSel).prepend @_childView?.render().el

    _viewCleanup: ->
      @$el.off('hidden')
      if @_childView?
        @_childView.close?()
        @_childView.remove()

    _bindDomEvents: ->
      @$el.on 'hidden', _.bind(@_onModalHidden, @)

    _trackLightbox: (opts) ->
      return if opts.supressTracking
      return unless @options.app?
      if typeof opts is 'string'
        name = opts
      else if opts.title
        name = opts.title
      else
        return null # No point tracking without a title for the lightbox
      @options.app.analytics.track(
        @options.app.analytics.CATEGORIES.viewLightbox, name, 'options', opts
      )


    # ---------------------------------------------------------------------- Public API
    show: (options) ->
      @model = new PerchModel()
      # Start with the default classnames
      @$el.prop 'class', _defaultClassnames
      # Allow Different Sizes
      if options.large
        # nuttin'
      else if options.huge
        @$el.addClass 'huge'
      else
        @$el.addClass 'small'
      # Let folks add a class
      @$el.addClass options.className if options.className?
      @listenTo @model, 'change', @render
      if typeof options == 'string'
        @_showSimpleMsg options
      else if options?.content instanceof Backbone.View
        @_showBackboneView options
      else
        @_showOptionsObject options
      @_trackLightbox options
      return this

    hide: ->
      @$el.modal 'hide'


  # Return a singleton
  perch = new Me()
  perch.Klass = Me # allows others to extend this class while leaving the object as a singleton
  return perch