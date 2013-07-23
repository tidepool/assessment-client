
define [
  'underscore'
  'backbone'
  'Handlebars'
  'text!./action_items.hbs'
  'entities/cur_user_actions'
], (
  _
  Backbone
  Handlebars
  tmpl
  NextAction
) ->

  _greetings = [
    'Hello'
    'Hi'
    'Aloha'
    'Bonjour'
    'Hola'
    'Hallo'
    'Ahoy'
    'G\'Day'
    'Howdy'
    'Hiya'
  ]
  Handlebars.registerHelper 'pickOne', (array) ->
    array[Math.floor(Math.random()*array.length)]

  _tmpl = Handlebars.compile tmpl

  TYPETOICON =
    Website:       'gfx-recommend_website'
    Video:         'gfx-recommend_video'
    Course:        'gfx-recommend_course'
    Comic:         'gfx-recommend_comic'
    Book:          'gfx-recommend_book'
    App:           'gfx-recommend_app'
    Activity:      'gfx-recommend_activity'
    ReactionTime:  'gfx-reactiontime'
    Emotions:      'gfx-emotiongame'
    Preferences:   'icon-cog'

  View = Backbone.View.extend
    className: 'actionItems'
    events:
      'click a': 'onClick'

    # -------------------------------------------------------- Backbone Methods
    initialize: ->
      @collection = new NextAction()
      @listenTo @collection, 'sync', @onSync
      @collection.fetch()

    render: ->
#      console.log collection:@collection.toJSON()
      first = @collection.at 0
      data = _.extend first.attributes, greetings:_greetings
      data.icon = TYPETOICON[data.link_type]
      @$el.html _tmpl data
      @

    onSync: ->
      @render()

    # Track when a next action rec is followed
    onClick: (e) ->
      $a = $(e.currentTarget)
      title = $a.prop 'href'
      # Track if there's a title
      if title and @options.app
        @options.app.analytics.track 'Action Items', "Clicked #{title}"


  View
