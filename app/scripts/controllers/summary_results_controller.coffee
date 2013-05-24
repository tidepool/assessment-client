define [
  'jquery'
  'backbone'
  'components/results_progress_bar_view'
  'results/profile_summary_view'
  'results/scores_summary_view'
  'results/mechanical_turk_view'
], (
  $
  Backbone
  ResultsProgressBarView
  ProfileSummaryView
  ScoresSummaryView
  MechanicalTurkView
) ->
  SummaryResultsController = ->
    views:
      'Profile': 'ProfileSummaryView'
      'Scores': 'ScoresSummaryView'
      'MT': 'MechanicalTurkView'

    initialize: (options) ->
      @session = options.session
      @assessment = @session.assessment
      
    render: ->
      @fetchResult()
      .done => 
        definition = @assessment.get('definition')
        viewClassString = @views[definition.result_view]
        viewClass = eval(viewClassString)
        view = new viewClass({assessment: @assessment})
        $('#content').html(view.render().el)
      .fail =>
        console.log('TODO:Failed View needs to be displayed')

    fetchResult: ->
      deferred = $.Deferred()
      view = new ResultsProgressBarView()
      $('#content').html(view.render().el)
      @assessment.getResult()
      .done =>
        deferred.resolve()
      .fail =>
        deferred.reject()

      # @assessment.addUser(@session.user)
      # .done =>        
      #   @result.calculateResult()
      #   .done =>
      #     console.log('Fetch Results calculated results')
      #     deferred.resolve('Calculated Results')
      #   .fail => 
      #     console.log('Fetch Results Failed')
      #     deferred.reject()
      deferred.promise()

  SummaryResultsController