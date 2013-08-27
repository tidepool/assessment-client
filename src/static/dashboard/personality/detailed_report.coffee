
define [
  'backbone'
  'dashboard/widgets/base'
  'text!./detailed_report.hbs'
  'composite_views/perch-psst'
  'core'
], (
  Backbone
  Widget
  tmpl
  perchPsst
  app
) ->

  _className = 'detailedReport'

  View = Widget.extend
    className: _className
    events:
      'click .widget': 'onClick'

    render: ->
      @$el.html tmpl
      @

    onClick: ->
      if app.user.attributes.email
        msg = "Thanks for your interest, we'll notify you at <strong>#{app.user.attributes.email}</strong> when your report is available"
      else
        msg = "Thanks for your interest, we'll notify you when your report is available"
      perchPsst.show
        msg: msg
        icon: 'icon-ok'
      $.ajax
        url: "#{app.cfg.apiServer}/api/v1/users/-/preorders"
        type: 'POST'
      .fail (jqXHR, textStatus, errorThrown) =>
        throw new Error "Failed to send preorder for #{app.user.attributes.email}"

  View


