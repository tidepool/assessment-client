
define [
  'backbone'
  'Handlebars'
  'entities/cur_user_personality'
  'text!./all.hbs'
  'core'
  'composite_views/perch'
  # Dashboard Widgets
  'dashboard/widget-lister'
  'dashboard/widget-careerRecc'
], (
  Backbone
  Handlebars
  UserPersonality
  tmpl
  app
  perch
  WidgetLister
  WidgetCareerRecc
) ->

  _widgetMasterSel = '#WidgetMaster'

  View = Backbone.View.extend

    className: 'dashboardPage career'

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


      careerRecc = new WidgetCareerRecc()
      $mastahBlastah.append careerRecc.render().el

      skillz = new WidgetLister
        title: 'Skills to Work On'
        className: 'coolTones'
        icon: 'icon-ok' # optional, override the bullet icon
        list: [
          'Complex problem solving'
          'Critical thinking'
          'Managerial ability'
          'Oral expression'
        ]
      $mastahBlastah.append skillz.render().el

      skillz = new WidgetLister
        title: 'Tools of the Trade'
        className: 'coolTones'
        list: [
          'High end computer servers'
          'Operating system software'
          'Object or component oriented software development'
        ]
      $mastahBlastah.append skillz.render().el



  # ---------------------------------------------------------------- Event Callbacks
    onUserSync: -> @_getPersonality()
    onLogOut: -> app.router.navigate 'home', trigger:true
    onModelSync: (model, data) -> @_addWidgets()
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

