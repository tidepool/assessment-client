
define [
  './_base'
], (
  DashboardBaseView
) ->

  View = DashboardBaseView.extend
    title: 'Productivity Dashboard'
    className: 'dashboard-productivity'
    render: -> @renderWidgets [
      'dashboard/career/reaction_history'
      'dashboard/career/reaction_results'
      'dashboard/teasers/emotions'
      'dashboard/career/jobs'
      'dashboard/career/skills'
      'dashboard/career/tools'
#      'dashboard/teasers/snoozer'
    ]

  View

