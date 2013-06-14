
define [
  'backbone'
  'Handlebars'
  'entities/cur_user_personality'
  'text!./personality.hbs'
  # Dashboard Widgets
  'dashboard/widget-coreResults'
  'dashboard/widget-personalityChart'
  'dashboard/widget-interestsChart'
  'text!dashboard/widget-randomRecc.hbs'
  'text!dashboard/widget-premiumTeaser.hbs'
  'text!dashboard/widget-emptyCareer.hbs'
  'text!dashboard/widget-emptyHappiness.hbs'
  'composite_views/perch'
], (
  Backbone
  Handlebars
  UserPersonality
  tmpl
  WidgetCoreResults
  WidgetPersonalityChart
  WidgetInterestsChart
  tmplRandomRecc
  tmplPremiumTeaser
  tmplEmptyCareer
  tmplEmptyHappiness
  perch
) ->

  _widgetMasterSel = '#WidgetMaster'

  View = Backbone.View.extend

    className: 'dashboardPage'

    initialize: ->
      @model = new UserPersonality()
      @listenTo @model, 'sync', @onModelSync
      @listenTo @model, 'error', @onModelErr

    render: ->
      @$el.html tmpl
      #@_addWidgets()
      @


    # ---------------------------------------------------------------- Private
    _addWidgets: ->
      $mastahBlastah = @$(_widgetMasterSel)
      coreResults = new WidgetCoreResults
        model: new Backbone.Model @model.attributes.profile_description
      $mastahBlastah.append coreResults.render().el
      personalityChart = new WidgetPersonalityChart()
      $mastahBlastah.append personalityChart.render().el
      $mastahBlastah.append tmplPremiumTeaser
      $mastahBlastah.append tmplEmptyHappiness
      interestsChart = new WidgetInterestsChart()
      $mastahBlastah.append interestsChart.render().el
      $mastahBlastah.append tmplRandomRecc
      #$mastahBlastah.append tmplEmptyCareer


    # ---------------------------------------------------------------- Event Callbacks
    onModelSync: (model, data) ->
      @_addWidgets()

    onModelErr: (model, xhr) ->
      console.log
        model: model
        xhr: xhr
      perch.show
        title: 'Doh. Pretty Srs Error.'
        msg: 'So Sorry, we\'re having trouble getting your personality data.'
        btn1Text: 'Try Again'
        onClose: -> app.router.navigate('dashboard', trigger: true)


  View

