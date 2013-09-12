
define [
  'backbone'
  'Handlebars'
  'text!./jobs.hbs'
  'dashboard/widgets/base'
  'ui_widgets/share'
], (
  Backbone
  Handlebars
  tmpl
  Widget
  ShareView
) ->


  Handlebars.registerHelper 'commaList', (array) ->
    prettyList = ''
    prettyList += "#{item}, " for item in array
    return prettyList.slice(0, -2)

  _tmpl = Handlebars.compile tmpl



  View = Widget.extend
    className: 'holder doubleWide coolTones career-jobs'
    render: ->
      @$el.html _tmpl @model.attributes
      share = new ShareView data:
        title: "My recommended careers are: '#{Handlebars.helpers.commaList(@model.attributes.careers)}'"
        text: 'You can find out your recommended careers, too, at https://alpha.tidepool.co'
        link: 'https://alpha.tidepool.co'
      @$el.append share.render().el
      @


  View.dependsOn = 'entities/my/career'
  View


