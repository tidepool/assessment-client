
define [
  'backbone'
  'Handlebars'
  'text!./widget-dailyRecc.hbs'
  'text!./widget-dailyReccDetails.hbs'
  'entities/cur_user_recommendations'
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
    className: "holder #{_className}"
    tagName: 'section'
    events:
      'click .widget': 'onClick'

    initialize: ->
      @model = new Recommedations()
      @listenTo @model, 'sync', @onSync
      @model.latest()

    render: ->
      @$el.html tmpl
      data = @model.attributes
      # Convert server link types to icons I can use
      switch data.link_type
        when 'Book'    then data.icon = 'icon-book'
        when 'App'     then data.icon = 'icon-cloud-download'
        when 'Video'   then data.icon = 'icon-youtube-play'
        when 'Comic'   then data.icon = 'icon-smile'
        when 'Lecture' then data.icon = 'icon-bullhorn'
      @_detailsMarkup = @tmplDetails data
      @


    # -------------------------------------------------------------- Event Handlers
    onSync: (model) ->
      @render() if model.attributes.sentence # only render if there is model content

    onClick: ->
      return unless @_detailsMarkup
      perch.show
        content: @_detailsMarkup
        btn1Text: null
        supressTracking: true
        large: true
      app.analytics.track _className, 'Shown'
      $(_recLinkSel).one 'click', @onReccClick

    onReccClick: ->
      app.analytics.track _className, 'External Link Clicked'



  View


