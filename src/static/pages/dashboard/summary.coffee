
define [
  './_base'
], (
  DashboardBaseView
) ->

  View = DashboardBaseView.extend
    title: 'Summary Dashboard'
    className: 'dashboard-summary'
    render: -> @renderWidgets [
      'dashboard/career/reaction_history'
      'dashboard/emotions/historical_highest'
      'dashboard/personality/big5'
      'dashboard/teasers/personalizations'
      'dashboard/teasers/reaction_time'
    ]

  View

