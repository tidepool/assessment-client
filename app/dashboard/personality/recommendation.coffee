
define [
  'backbone'
  'Handlebars'
  'dashboard/widgets/base'
  'text!./recommendation.hbs'
  'text!./recommendation-details.hbs'
  'composite_views/perch'
  'core'
], (
  Backbone
  Handlebars
  Widget
  tmpl
  tmplDetails
  perch
  app
) ->

  _className = 'recommendation'
  _recLinkSel = '#ActionRecommendationLink'
  _tmplDetails = Handlebars.compile tmplDetails

  View = Widget.extend
    className: _className
    events:
      'click .widget': 'onClick'

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
      @_detailsMarkup = _tmplDetails data
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


  View.dependsOn = 'entities/cur_user_recommendations'
  View


