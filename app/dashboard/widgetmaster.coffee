
define [
  'underscore'
  'backbone'
  # Available Widgets - Personality
  'dashboard/personality/core'
  'dashboard/personality/big5'
  'dashboard/personality/holland6'
  'dashboard/personality/detailed_report'
  'dashboard/personality/recommendation'
  # Available Widgets - Career
  'dashboard/career/jobs'
  'dashboard/career/skills'
  'dashboard/career/tools'
  # Available Widgets - Teasers
  'dashboard/teasers/reaction_time'
  # Available Models
  'entities/cur_user_career'
  'entities/cur_user_recommendations'
  'entities/cur_user_personality'
], (
  _
  Backbone
  WidgetPersonalityCore
  WidgetPersonalityBig5
  WidgetPersonalityHolland6
  WidgetPersonalityDetailedReport
  WidgetPersonalityRecommendation
  WidgetCareerJobs
  WidgetCareerSkills
  WidgetCareerTools
  WidgetTeasersReactionTime
  CurUserCareer
  CurUserRecommendations
  CurUserPersonality
) ->

  # keeping a key to these is a way to have widgetmaster preload all of them instead of dynamically requiring each one
  _widgets =
    'dashboard/career/jobs': WidgetCareerJobs
    'dashboard/career/skills': WidgetCareerSkills
    'dashboard/career/tools': WidgetCareerTools
    'dashboard/personality/core': WidgetPersonalityCore
    'dashboard/personality/big5': WidgetPersonalityBig5
    'dashboard/personality/holland6': WidgetPersonalityHolland6
    'dashboard/personality/detailed_report': WidgetPersonalityDetailedReport
    'dashboard/personality/recommendation': WidgetPersonalityRecommendation
    'dashboard/teasers/reaction_time': WidgetTeasersReactionTime
  _models =
    'entities/cur_user_career': CurUserCareer
    'entities/cur_user_recommendations': CurUserRecommendations
    'entities/cur_user_personality': CurUserPersonality

  _me = 'dashboard/widgetmaster'

  View = Backbone.View.extend
    className: 'widgetmaster'
    id: 'Widgetmaster'

    initialize: ->
      throw new Error "Need @options.widgets" unless @options.widgets
      # Intantiate one of each model class that our widgets need
      @models = @_makeModelsFromWidgets @options.widgets
      # Instantiate each widget view and give it a reference to the model it needs
      @widgets = @_makeWidgets @options.widgets, @models
      # fetch all models
      model.fetch() for key, model of @models

    render: ->
      @$el.empty()
      @$el.append widget.el for widget in @widgets
      return this


    # -------------------------------------------------------- Private Methods
    _makeModelsFromWidgets: (widgetNames) ->
      modelClassesByKey = {}
      for name in widgetNames
        if _widgets[name] # Is this one of the views we've loaded?
          Widget = _widgets[name]
          if not Widget.dependsOn
#            console.log "#{_me}: #{name} does not depend on a model and that's ok."
          else if _models[Widget.dependsOn]
            modelClassesByKey[Widget.dependsOn] = _models[Widget.dependsOn]
          else
            console.error "#{_me}: #{name}.dependsOn `#{Widget.dependsOn}`, but there is no model loaded with that name"
        else
          console.error "#{_me}: no widget available called `#{name}`"
      # Instantiate each model class
      modelsByKey = {}
      for key, Model of modelClassesByKey
        modelsByKey[key] = new Model()
      return modelsByKey

    _makeWidgets: (widgetNames, models) ->
      widgets = []
      for name in widgetNames
        if _widgets[name] # Is this one of the views we've loaded?
          Widget = _widgets[name]
          if Widget.dependsOn
            widgets.push new Widget
              model: models[Widget.dependsOn]
          else
            widgets.push new Widget()
        else
          console.error "#{_me}: no widget available called `#{name}`"
      return widgets





  View


