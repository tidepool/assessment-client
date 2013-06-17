
define [
  'backbone'
  'Handlebars'
  'text!./widget-dailyRecc.hbs'
  'text!./widget-dailyReccDetails.hbs'
  'entities/recommendations'
  'composite_views/perch'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  tmplDetails
  Recommedations
  perch
  app
) ->

  _widgetSel = '.widget'
  _className = 'dailyRecc'
  _recLinkSel = '#ActionRecommendationLink'

  View = Backbone.View.extend
    tmplDetails: Handlebars.compile tmplDetails
    className: 'holder dailyRecc'
    tagName: 'section'
    events:
      click: 'onClick'

    initialize: ->
      @model = new Recommedations()
      @listenTo @model, 'sync', @render

      @model.latest()

    render: ->
      @$el.html tmpl
      data = @model.attributes
      # Convert server link types to icons I can use
      switch data.link_type
        when 'Book' then data.style = 'book'
        when 'App' then data.style = 'cloud-download'
        when 'Video' then data.style = 'youtube-play'
      @_detailsMarkup = @tmplDetails data
      @


    # -------------------------------------------------------------- Event Handlers
    onClick: ->
      return unless @_detailsMarkup
      perch.show
        content: @_detailsMarkup
        btn1Text: null
        supressTracking: true
        large: true
      app.analytics.track _className, 'Recommendation Shown'
      $(_recLinkSel).one 'click', @onReccClick

    onReccClick: ->
      app.analytics.track _className, 'Recommendation Clicked'



  View


