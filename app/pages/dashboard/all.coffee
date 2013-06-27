
define [
  'backbone'
  'Handlebars'
  'core'
  'dashboard/widgetmaster'
], (
  Backbone
  Handlebars
  app
  Widgetmaster
) ->

  View = Backbone.View.extend

    className: 'dashboard-all'

    initialize: ->
      @listenTo app.user, 'sync', @render
      @listenTo app, 'session:logOut', @onLogOut
      app.trigger 'session:showLogin' unless app.user.isLoggedIn()

    render: ->
      @widgetmaster = new Widgetmaster
        widgets: [
          'dashboard/personality/core'
          'dashboard/personality/big5'
          'dashboard/teasers/reaction_time'
          'dashboard/personality/holland6'
          'dashboard/personality/detailed_report'
          'dashboard/career/jobs'
          'dashboard/career/skills'
          'dashboard/career/tools'
          'dashboard/personality/recommendation'
        ]
      @$el.html @widgetmaster.render().el
      return this


#        model: new Backbone.Model @model.attributes.big5_score
#        model: new Backbone.Model @model.attributes.holland6_score



    # ---------------------------------------------------------------- Private


    # ---------------------------------------------------------------- Event Callbacks
    onLogOut: -> app.router.navigate 'home', trigger:true


  View

