
define [
  './_base'
], (
  DashboardBaseView
) ->

  View = DashboardBaseView.extend
    title: 'Dashboard'
    className: 'dashboard-all'
    render: -> @renderWidgets [
      'dashboard/personality/core'
      'dashboard/personality/big5'
      'dashboard/personality/detailed_report'
      'dashboard/personality/holland6'
      'dashboard/personality/recommendation'
      'dashboard/career/jobs'
      'dashboard/teasers/reaction_time'
      'dashboard/teasers/emotions'
      'dashboard/career/skills'
      'dashboard/career/tools'
      'dashboard/emotions/historical_highest'
      'dashboard/emotions/highest_emotion'
      'dashboard/emotions/strongest_emotions'
    ]

  View

