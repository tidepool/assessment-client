
define [
  'backbone'
  'Handlebars'
  'entities/cur_user_personality'
  'text!./personality.hbs'
  'core'
  'composite_views/perch'
  # Dashboard Widgets
  'dashboard/widget-coreResults'
  'dashboard/widget-personalityChart'
  'dashboard/widget-interestsChart'
  'dashboard/widget-dailyRecc'
  'dashboard/widget-personalityReport'
], (
  Backbone
  Handlebars
  UserPersonality
  tmpl
  app
  perch
  WidgetCoreResults
  WidgetPersonalityChart
  WidgetInterestsChart
  WidgetDailyRecc
  WidgetPersonalityReport
) ->

  _widgetMasterSel = '#WidgetMaster'

  View = Backbone.View.extend

    className: 'dashboardPage'

    initialize: ->
      @model = new UserPersonality()
      _.bindAll @, '_getPersonality'
      @_getPersonality()
      @listenTo @model, 'sync', @onModelSync
      @listenTo @model, 'error', @onModelErr
      @listenTo app.user, 'sync', @onUserSync
      @listenTo app, 'session:logOut', @onLogOut

    render: ->
      @$el.html tmpl
      #@_addWidgets()
      @


    # ---------------------------------------------------------------- Private
    _getPersonality: ->
      if app.user.isLoggedIn()
        @model.fetch()
      else
        app.trigger 'session:showLogin'

    _emptyWidgets: ->
      @$(_widgetMasterSel).empty()

    _addWidgets: ->
      @_emptyWidgets()
      $mastahBlastah = @$(_widgetMasterSel)

      coreResults = new WidgetCoreResults
        model: new Backbone.Model @model.attributes.profile_description
      $mastahBlastah.append coreResults.render().el

      personalityChart = new WidgetPersonalityChart
        model: new Backbone.Model @model.attributes.big5_score
      $mastahBlastah.append personalityChart.render().el

      personalityReport = new WidgetPersonalityReport()
      $mastahBlastah.append personalityReport.render().el

      interestsChart = new WidgetInterestsChart
        model: new Backbone.Model @model.attributes.holland6_score
      $mastahBlastah.append interestsChart.render().el

      dailyRecc = new WidgetDailyRecc()
      $mastahBlastah.append dailyRecc.el


    # ---------------------------------------------------------------- Event Callbacks
    onUserSync: -> @_getPersonality()
    onLogOut: -> app.router.navigate 'home', trigger:true

    onModelSync: (model, data) ->
      @_addWidgets()

    onModelErr: (model, xhr) ->
#      console.log
#        model: model
#        xhr: xhr
      perch.show
        title: 'You Must Be Veeery Special...'
        msg: 'So Sorry, we\'re having trouble getting your personality data.'
        btn1Text: 'Darn'
        #onClose: -> app.router.navigate('dashboard', trigger: true)


  View

