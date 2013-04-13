define [
  'jquery',
  'Backbone',
  'components/results_progress_bar_view',
  'results/profile_summary_view',
  'results/scores_summary_view',
  'results/mechanical_turk_view',
  'models/stage',
  'models/assessment',
  'models/session'], ($, Backbone, ResultsProgressBarView, ProfileSummaryView, ScoresSummaryView, MechanicalTurkView) ->
  SummaryResultsController = ->
    views:
      'Profile': 'ProfileSummaryView'
      'Scores': 'ScoresSummaryView'
      'MT': 'MechanicalTurkView'

    initialize: (options) ->
      @assessment = options.assessment
      @session = options.session
      @definition = @assessment.get('definition')
      @result = options.result

    fetchResults: ->
      deferred = $.Deferred()
      view = new ResultsProgressBarView()
      $('#content').html(view.render().el)
      @assessment.addUser(@session.user)
      .done =>        
        @result.calculateResult()
        .done =>
          console.log('Fetch Results calculated results')
          deferred.resolve('Calculated Results')
        .fail => 
          console.log('Fetch Results failed')
          deferred.reject()
      deferred.promise()

    render: ->
      @fetchResults()
      .done => 
        viewClassString = @views[@definition.result_view]
        viewClass = eval(viewClassString)
        view = new viewClass({model: @result, assessments: @assessment})
        $('#content').html(view.render().el)
      .fail =>
        console.log('TODO:Failed View needs to be displayed')

  SummaryResultsController