
define [
  'backbone'
  'Handlebars'
  'text!./all.hbs'
  'core'
  'composite_views/perch'
  'entities/cur_user_career'
  # Dashboard Widgets
  'dashboard/widget-lister'
  'dashboard/widget-careerRecc'
], (
  Backbone
  Handlebars
  tmpl
  app
  perch
  CareerRecommendations
  WidgetLister
  WidgetCareerRecc
) ->

  _widgetMasterSel = '#WidgetMaster'

  View = Backbone.View.extend

    className: 'dashboardPage career'

    initialize: ->
      @model = new CareerRecommendations()
      _.bindAll @, '_getRecommendations'
      @_getRecommendations()
      @listenTo @model, 'sync', @onModelSync
      @listenTo @model, 'error', @onModelErr
      @listenTo app.user, 'sync', @onUserSync
      @listenTo app, 'session:logOut', @onLogOut

    render: ->
      @$el.html tmpl
      return this


  # ---------------------------------------------------------------- Private
    _getRecommendations: ->
      if app.user.isLoggedIn()
        @model.fetch()
      else
        app.trigger 'session:showLogin'

    _emptyWidgets: ->
      @$(_widgetMasterSel).empty()

    _addWidgets: ->
      @_emptyWidgets()
      $mastahBlastah = @$(_widgetMasterSel)

      careerRecc = new WidgetCareerRecc
        model: @model
      $mastahBlastah.append careerRecc.render().el

      skillz = new WidgetLister
        title: 'Skills to Work On'
        className: 'coolTones'
        icon: 'icon-ok' # optional, override the bullet icon
        list: @model.attributes.skills
      $mastahBlastah.append skillz.render().el

      toolz = new WidgetLister
        title: 'Tools of the Trade'
        className: 'coolTones'
        list: @model.attributes.tools
      $mastahBlastah.append toolz.render().el

      return this



  # ---------------------------------------------------------------- Event Callbacks
    onUserSync: -> @_getPersonality()
    onLogOut: -> app.router.navigate 'home', trigger:true
    onModelSync: (model, data) -> @_addWidgets()
    onModelErr: (model, xhr) ->
      perch.show
        title: 'Oops...'
        msg: 'So Sorry, we\'re having trouble getting your career data.'
        btn1Text: 'Darn'



  View

