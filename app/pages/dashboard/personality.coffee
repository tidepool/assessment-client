
define [
  './_base'
], (
  DashboardBaseView
) ->

  View = DashboardBaseView.extend
    title: 'Personality Dashboard'
    className: 'dashboard-personality'
    render: -> @renderWidgets [
        'dashboard/personality/core'
        'dashboard/personality/big5'
        'dashboard/personality/holland6'
        'dashboard/personality/detailed_report'
      ]

  View

