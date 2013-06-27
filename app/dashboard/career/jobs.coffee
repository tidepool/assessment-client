
define [
  'backbone'
  'Handlebars'
  'text!./jobs.hbs'
  'dashboard/widgets/base'
], (
  Backbone
  Handlebars
  tmpl
  Widget
) ->


  Handlebars.registerHelper 'commaList', (array) ->
    prettyList = ''
    prettyList += "#{item}, " for item in array
    return prettyList.slice(0, -2)

  _tmpl = Handlebars.compile tmpl



  View = Widget.extend
    className: 'holder doubleWide coolTones career-jobs'
    events:
      'click .icon-briefcase': 'onClickBriefcase'
    render: ->
      @$el.html _tmpl @model.attributes
      @

    onClickBriefcase: ->
      console.log "Magical briefcase clicked"


  View.dependsOn = 'entities/cur_user_career'
  View


