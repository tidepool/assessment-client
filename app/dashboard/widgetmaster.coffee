
define [
  'underscore'
  'backbone'
  'core'
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
  'dashboard/career/reaction_results'
  'dashboard/career/reaction_history'
  # Widgets - Emotions
  'dashboard/emotions/highest_emotion'
  'dashboard/emotions/historical_highest'
  'dashboard/emotions/strongest_emotions'
  # Available Widgets - Teasers
  'dashboard/teasers/reaction_time'
  'dashboard/teasers/emotions'
  'dashboard/teasers/personalizations'
  # Available Models
  'entities/cur_user_career'
  'entities/cur_user_recommendations'
  'entities/cur_user_personality'
  'entities/results/results'
  'entities/preferences/training'
], (
  _
  Backbone
  app
  WidgetPersonalityCore
  WidgetPersonalityBig5
  WidgetPersonalityHolland6
  WidgetPersonalityDetailedReport
  WidgetPersonalityRecommendation
  WidgetCareerJobs
  WidgetCareerSkills
  WidgetCareerTools
  WidgetCareerReactionResults
  WidgetCareerReactionHistory
  WidgetEmotionsHighest
  WidgetEmotionsHighestHistory
  WidgetEmotionsStrongest
  WidgetTeaserReactionTime
  WidgetTeaserEmotions
  WidgetTeaserPersonalizations
  CurUserCareer
  CurUserRecommendations
  CurUserPersonality
  Results
  TrainingPreferences
) ->

  # keeping a key to these is a way to have widgetmaster preload all of them instead of dynamically requiring each one
  _widgets =
    'dashboard/career/jobs': WidgetCareerJobs
    'dashboard/career/skills': WidgetCareerSkills
    'dashboard/career/tools': WidgetCareerTools
    'dashboard/career/reaction_results': WidgetCareerReactionResults
    'dashboard/career/reaction_history': WidgetCareerReactionHistory
    'dashboard/personality/core': WidgetPersonalityCore
    'dashboard/personality/big5': WidgetPersonalityBig5
    'dashboard/personality/holland6': WidgetPersonalityHolland6
    'dashboard/personality/detailed_report': WidgetPersonalityDetailedReport
    'dashboard/personality/recommendation': WidgetPersonalityRecommendation
    'dashboard/emotions/highest_emotion': WidgetEmotionsHighest
    'dashboard/emotions/historical_highest': WidgetEmotionsHighestHistory
    'dashboard/emotions/strongest_emotions': WidgetEmotionsStrongest
    'dashboard/teasers/reaction_time': WidgetTeaserReactionTime
    'dashboard/teasers/emotions': WidgetTeaserEmotions
    'dashboard/teasers/personalizations': WidgetTeaserPersonalizations
  _models =
    'entities/cur_user_career': CurUserCareer
    'entities/cur_user_recommendations': CurUserRecommendations
    'entities/cur_user_personality': CurUserPersonality
    'entities/results/results': Results
    'entities/preferences/training': TrainingPreferences

  # model instances are keyed by module id (essentially a class name) and fetch options. This way data can be shared between widgets.
  _keyBuilder = (Widgy) ->
    moduleId = Widgy.dependsOn
    options = Widgy.fetchOptions
    if options
      key = "#{moduleId}?fetchOptions=#{JSON.stringify(options)}" # model instances are keyed by class name and fetch options. This way data can be shared between widgets.
    else
      key = moduleId
    return key



  _me = 'dashboard/widgetmaster'

  View = Backbone.View.extend
    className: 'widgetmaster'
    id: 'Widgetmaster'

    initialize: ->
      throw new Error "Need @options.widgets" unless @options.widgets
      # Intantiate one of each model class that our widgets need
      @dataSources = @_makeModelsFromWidgets @options.widgets
      # Instantiate each widget view and give it a reference to the model it needs
      @widgets = @_makeWidgets @options.widgets, @dataSources
      # fetch all models
#      console.log dataSources:@dataSources
      fetchPromises = []
      for key, dataSource of @dataSources
        fetchPromises.push dataSource.fetch dataSource.fetchOptions
      $.when.apply($, fetchPromises).done @_countResults # Do this when all results resolve

    render: ->
      @$el.empty()
      @$el.append widget.el for widget in @widgets
      return this


    # -------------------------------------------------------- Private Methods
    _makeModelsFromWidgets: (widgetNames) ->
      modelClassesByKey = {}
      fetchOptionsByKey = {}
      for name in widgetNames
        if _widgets[name] # Is this one of the views we've loaded?
          Widget = _widgets[name]
          if not Widget.dependsOn
#            console.log "#{_me}: #{name} does not depend on a model and that's ok."
          else if _models[Widget.dependsOn]
            key = _keyBuilder Widget
            modelClassesByKey[key] = _models[Widget.dependsOn]
            fetchOptionsByKey[key] = Widget.fetchOptions
          else
            console.error "#{_me}: #{name}.dependsOn `#{Widget.dependsOn}`, but there is no model loaded with that name"
        else
          console.error "#{_me}: no widget available called `#{name}`"
      # Instantiate each model class
      modelsByKey = {}
#      console.log modelClassesByKey:modelClassesByKey

      for key, Model of modelClassesByKey
        modelsByKey[key] = new Model()
        modelsByKey[key].fetchOptions = fetchOptionsByKey[key]
      # Store fetch options on the model instance if the view has them
      return modelsByKey

    _makeWidgets: (widgetNames, dataSources) ->
      widgets = []
      for name in widgetNames
        if _widgets[name] # Is this one of the views we've loaded?
          Widget = _widgets[name]
          if Widget.dependsOn
            key = _keyBuilder Widget
            dataSource = dataSources[key]
            if dataSource instanceof Backbone.Model
              widgets.push new Widget
                model: dataSource
            else if dataSource instanceof Backbone.Collection
              widgets.push new Widget
                collection: dataSource
            else
              console.error "#{_me}: This object is neither a collection nor a model: "
              console.log dataSource
          else
            widgets.push new Widget()
        else
          console.error "#{_me}: no widget available called `#{name}`"
      return widgets

    # Count the results, presuming that this is called on a .done from $.when(), which returns a particular format
    # http://api.jquery.com/jQuery.when/
    _countResults: ->
      count = 0
      if arguments[1] is 'success' #single fetch result
        data = arguments[0]
        count += data.length if _.isArray data
      else # mutliple
        for result in arguments
          data = result[0]
          count += data.length if _.isArray data
#      console.log count:count
      prevCount = app.user.get('gamesPlayed') || 0
      app.user.set gamesPlayed: Math.max(count, prevCount)
      count

  View
