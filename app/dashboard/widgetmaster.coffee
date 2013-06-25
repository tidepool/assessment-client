
define [
  'underscore'
  'backbone'
  # Available Widgets - Personality
  'dashboard/personality/core'
  # Available Widgets - Career
  'dashboard/career/jobs'
  'dashboard/career/skills'
  'dashboard/career/tools'
  # Available Models
  'entities/cur_user_career'
  'entities/cur_user_recommendations'
  'entities/cur_user_personality'
], (
  _
  Backbone
  WidgetPersonalityCore
  WidgetCareerJobs
  WidgetCareerSkills
  WidgetCareerTools
  CurUserCareer
  CurUserRecommendations
  CurUserPersonality
) ->

  _widgets =
    'dashboard/career/jobs': WidgetCareerJobs
    'dashboard/career/skills': WidgetCareerSkills
    'dashboard/career/tools': WidgetCareerTools
    'dashboard/personality/core': WidgetPersonalityCore
    'dashboard/personality/big5': null
    'dashboard/personality/holland6': null
    'dashboard/personality/detailed_report': null
    'dashboard/personality/recommendation': null
  _models =
    'entities/cur_user_career': CurUserCareer
    'entities/cur_user_recommendations': CurUserRecommendations
    'entities/cur_user_personality': CurUserPersonality

  _me = 'dashboard/widgetmaster'

  View = Backbone.View.extend
    className: 'widgetmaster'
    id: 'Widgetmaster'

    initialize: ->
      return unless @options.widgets
      # Intantiate one of each model class that our widgets need
      @models = @_makeModelsFromWidgets @options.widgets
      # Instantiate each widget view and give it a reference to the model it needs
      @widgets = @_makeWidgets @options.widgets, @models
      # fetch all models
      model.fetch() for key, model of @models

    render: ->
#      console.log
#        widgets: @widgets
#        _widgets: _widgets
#        _models: _models
      @$el.empty()
      @$el.append widget.el for widget in @widgets
      return this


    # -------------------------------------------------------- Private Methods
    _makeModelsFromWidgets: (widgetNames) ->
#      @widgets = [] # an array of all widgets and their options in the order of display
      modelClassesByKey = {}
      for name in widgetNames
        if _widgets[name] # Is this one of the views we've loaded?
          Widget = _widgets[name]
          if not Widget.dependsOn
            console.log "#{_me}: #{name} does not depend on a model and that's ok."
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


