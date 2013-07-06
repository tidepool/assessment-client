define [
  'backbone'
  'Handlebars'
  'text!./demographics.hbs'
  'ui_widgets/formation'
  './demographics-fields'
  'core'
], (
  Backbone
  Handlebars
  tmpl
  Formation
  demographicsFields
  app
) ->

  _formRegionSel = '#FormRegion'
  _startBtnSel = '#ActionStartGame'
  _letsGoBtnMarkup = '
    <a id="ActionStartGame" class="btn btn-large btn-primary btn-alt pull-right" href="#game">Save My Info and Let\'s Go</a>
  '
  _wrapperMarkup = '<div class="col3rds"></div>'
  _groups = [
    '.dob, .education'
    '.handedness'
    '.gender'
  ]

  Me = Backbone.View.extend
    title: 'Demographics'
    className: 'demographicsPage'
    events:
      'change input': 'onChangeInput'
      'change select': 'onChangeInput'
      'click #ActionStartGame': 'onClickContinue'

    initialize: ->
#      console.log "#{@className}.initialize()"
      @formation = new Formation
        data:demographicsFields
        values: app.user.attributes

    render: ->
      @$el.html tmpl
      @$(_formRegionSel).html @formation.render().el
      @
    onDomInsert: ->
      @_wrapGroups()

    _wrapGroups: ->
      $(group).wrapAll _wrapperMarkup for group in _groups

    onChangeInput: ->
      return if @_alreadyChanged
      @$(_startBtnSel).replaceWith _letsGoBtnMarkup
      @_alreadyChanged = true

    onClickContinue: ->
      demographics = @formation.getVals()
#      console.log demographics:demographics
      # Save the demographics if the user set any, but not if the user is `new`. New demographics are recorded on create

      unless _.isEmpty demographics
        app.user.set demographics
        unless app.user.isNew()
          jxhr = app.user.save
#        jxhr.done -> console.log 'save done'
#        jxhr.fail -> console.log 'save fail'

  Me

