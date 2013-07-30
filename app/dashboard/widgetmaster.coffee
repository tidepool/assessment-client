
define [
  'jquery'
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
  'dashboard/teasers/snoozer'
  # Available Widgets - Fitness
  'dashboard/fitness/steps_and_emotions'
  # Available Models
  'entities/my/career'
  'entities/my/recommendations'
  'entities/my/personality'
  'entities/results/results'
  'entities/preferences/training'
  'entities/my/activities'
], (
  $
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
  WidgetTeaserSnoozer
  WidgetStepsAndEmotions
  CurUserCareer
  CurUserRecommendations
  CurUserPersonality
  Results
  TrainingPreferences
  Activities
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
    'dashboard/teasers/snoozer': WidgetTeaserSnoozer
    'dashboard/fitness/steps_and_emotions': WidgetStepsAndEmotions
  _dataSources =
    'entities/my/career': CurUserCareer
    'entities/my/recommendations': CurUserRecommendations
    'entities/my/personality': CurUserPersonality
    'entities/results/results': Results
    'entities/preferences/training': TrainingPreferences
    'entities/my/activities': Activities

  # model instances are keyed by module id (essentially a class name) and fetch options. This way data can be shared between widgets.
  _keyBuilder = (moduleId, options) ->
#    moduleId = Widgy.dependsOn
#    options = Widgy.fetchOptions
    if options
      key = "#{moduleId}?fetchOptions=#{JSON.stringify(options)}" # model instances are keyed by class name and fetch options. This way data can be shared between widgets.
    else
      key = moduleId
    return key

  _widgetParentSel = '.holder'

  # These classnames change widget behavior and look/feel.
  # We want to be able to isolate then so we can get down to the semantic classname only when we want to.
  _stylingClassnames = [
    'holder'
    'tall'
    'doubleWide'
    'coolTones'
  ]



  _me = 'dashboard/widgetmaster'

  View = Backbone.View.extend
    className: 'widgetmaster'
    id: 'Widgetmaster'
    events:
      'click .widget.pressable': 'onClick'
      'click a.widget': 'onClick'

    initialize: ->
      throw new Error "Need @options.widgets" unless @options.widgets

      # Build keyed list of data dependencies
      @dataSources = @_setUpDataSources @options.widgets
      console.log dataSources:@dataSources

      # Instantiate each widget view and give it a reference to the dataSource(s) it needs
      @widgets = @_makeWidgets @options.widgets, @dataSources
      console.log widgets:@widgets

      # fetch all models
      fetchPromises = []
      for key, dataSource of @dataSources
        fetchPromises.push dataSource.fetch dataSource.fetchOptions
      $.when.apply($, fetchPromises).done @_countResults # Do this when all results resolve

    render: ->
      @$el.empty()
      @$el.append widget.el for widget in @widgets
      @


    # -------------------------------------------------------- Private Methods
    # Each widget declares the model or collection it needs
    # For each widget, look at what data source it needs
    _setUpDataSources: (widgetNames) ->
      dataSources = {}
      for name in widgetNames
        if _widgets[name] # Is this one of the views we've loaded?
          Widget = _widgets[name]
          if not Widget.dependsOn # console.log "#{_me}: #{name} does not depend on a model and that's ok."
          else if _.isObject Widget.dependsOn # Objects indicate multiple dependencies
            for name, dependency of Widget.dependsOn
#              console.log
#                dependencyClass:dependency.klass
#                fetchOptions:dependency.fetchOptions
              @_setUpDataSource dataSources, dependency.klass, dependency.fetchOptions
          else
            @_setUpDataSource dataSources, Widget.dependsOn, Widget.fetchOptions
        else
          console.error "#{_me}: no widget available called `#{name}`"
      dataSources

    # Set up one data source
    _setUpDataSource: (list, dependency, options) ->
      if _dataSources[dependency]
        key = _keyBuilder dependency, options
        Model = _dataSources[dependency]
        list[key] = new Model
        list[key].fetchOptions = options
          #source: _dataSources[dependency]
          #options: options
      else
        console.error "Looking for `#{dependency}`, but there is no model loaded with that name"

    # Instantiate a data source for each unique combination of model or collection and fetch options
    # Include any fetch options
#    _instantiateDataSources: (classes) ->
#      dataInstances = {}
#      for key, Model of classes
#        dataInstances[key] = new Model()
#        dataInstances[key].fetchOptions = @fetchOptionsByKey[key]
#      dataInstances

    _makeWidgets: (widgetNames, dataSources) ->
      widgets = []
      for name in widgetNames
        if _widgets[name] # Is this one of the views we've loaded?
          Widget = _widgets[name]
          # Widgets with more than one dependency
          if _.isObject Widget.dependsOn
            opts = {}
            for name, definition of Widget.dependsOn
              key = _keyBuilder definition.klass, definition.fetchOptions
              opts[name] = dataSources[key]
            console.log opts:opts
            widgets.push new Widget opts
          # Widgets with 1 dependency
          else if Widget.dependsOn
            key = _keyBuilder Widget.dependsOn, Widget.fetchOptions
            dataSource = dataSources[key]
            if dataSource instanceof Backbone.Model
              widgets.push new Widget
                model: dataSource
            else if dataSource instanceof Backbone.Collection
              widgets.push new Widget
                collection: dataSource
            else
              console.error "#{_me}: This object is neither a collection nor a model: "
              console.log dependsOn: Widget.dependsOn
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

    # Whenever a pressable widget is clicked, log to analytics with the "title" of the widget
    # Title is calculated based on the content of the widget
    onClick: (e) ->
      $widge = $(e.currentTarget)
      className = $widge.closest(_widgetParentSel).prop('class')
      className = className.replace word, '' for word in _stylingClassnames # Get rid of everything but semantic classnames
      title = className.trim()
      # Track if there's a title
      app.analytics.track 'Widget', "Clicked #{title}" if title




  View
