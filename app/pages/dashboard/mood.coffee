define [
  './_base'
], (
  DashboardBaseView
) ->

  View = DashboardBaseView.extend
    title: 'Mood Dashboard'
    className: 'dashboard-mood'
    render: -> @renderWidgets [
      'dashboard/emotions/highest_emotion'
      'dashboard/emotions/historical_highest'
      'dashboard/emotions/strongest_emotions'
      'dashboard/teasers/reaction_time'
    ]

  View

