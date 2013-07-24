
define [
  'backbone'
  'Handlebars'
  'text!./core.hbs'
  'dashboard/widgets/base'
  'composite_views/perch'
  'markdown'
  'core'
  'ui_widgets/share'
], (
  Backbone
  Handlebars
  tmpl
  Widget
  perch
  markdown
  app
  ShareView
) ->

  _widgetSel = '.widget'
  _className = 'corePersonality'
  _tmpl = Handlebars.compile tmpl

  View = Widget.extend
    className: "doubleWide tall #{_className}"
    events:
      'click .widget': 'onClick'

    render: ->
      @$el.html _tmpl @model.attributes.profile_description
      share = new ShareView data:
        title: "My personality is '#{@model.attributes.profile_description.name}'"
        text: 'You can find out your personality, too, at https://alpha.tidepool.co'
        link: 'https://alpha.tidepool.co'
        image: "https://alpha.tidepool.co/images/badges/#{@model.attributes.profile_description.logo_url}"
      @$el.append share.render().el
      @

    onClick: ->
      descHtml = markdown.toHTML @model.attributes.profile_description.description
      perch.show
        large: true
        title: @model.attributes.profile_description.name
        msg: descHtml
        btn1Text: 'Ok'


  View.dependsOn = 'entities/my/personality'
  View




