define [
  'underscore'
  'backbone'
  'Handlebars'
  'game/levels/_base'
  'text!./person_fill.hbs'
  'text!./person_text.hbs'
  './person_vessel_view'
  'ui_widgets/proceed'
],
(
  _
  Backbone
  Handlebars
  Level
  tmpl
  tmplPersonText
  PersonVesselView
  proceed
) ->


  _instructionsSel = '.instructions'
  _contentSel = '.people'
  _upKey = 38
  _downKey = 40
  _tmplPersonText = Handlebars.compile tmplPersonText


  Export = Level.extend

    # ----------------------------------------------------- Backbone Extensions
    className: 'personFill'
    initialize: ->
      @i = -1
      _.bindAll @, '_next'
      @listenTo proceed, 'click', @onProceedClick
      @listenTo @collection, 'change:size', @onChangeSize
      @once 'domInsert', @_calculateHeight
      @render()
      _.bindAll @, 'onKeyDown'
      $(window).on 'keydown', @onKeyDown

    render: ->
      @$el.html tmpl
#      console.log collection:@collection.toJSON()
      @_addPeople _contentSel
      setTimeout @_next, 100 # Start on the first one. Timeout makes it animate
      @


    # ----------------------------------------------------- Private Methods
    _calculateHeight: ->
#      margins = parseInt(@$el.css('margin-top')) #+ parseInt(@$el.css('margin-bottom'))
      availHeight = $(window).height() - @$el.offset().top
#      console.log
#        offset: @$el.offset().top
#        window: $(window).height()
#        availHeight: availHeight
#        margins: margins
      @$el.css height:availHeight
      @

    _addPeople: (sel) ->
      @collection.each (person) =>
        person.view = new PersonVesselView model: person
        @$(sel).append person.view.render().el
      @

    _showPerson: (index) ->
      model = @collection.at(index)
      return unless model
      @curPerson = model.view.yourTurn()
      @$(_instructionsSel).html _tmplPersonText model.attributes

    _finishPerson: (index) ->
      model = @collection.at(index)
      return unless model
      model.view.done()
      proceed.hide()

    _next: ->
      @_finishPerson @i
      @i++
      @_showPerson @i

    _finish: ->
      @collection.each (circle) -> circle.view?.remove?() #Close them down properly. Lets them assign widths and remove events.
      proceed.hide()
      @clearInteracted @collection
      @trigger 'done'
      @remove()


    # ----------------------------------------------------- Data Events
    onChangeSize: (model, size) ->
      @options.runner.track Level.EVENTS.resize,
        index: model.collection.indexOf model
        new_size: size


    # ----------------------------------------------------- Keyboard Events
    onKeyDown: (event) ->
      return unless @curPerson
      code = event.charCode || event.which
#      console.log
#        event:event
#        charCode: code
      switch code
        when _upKey then @curPerson.bumpUp()
        when _downKey then @curPerson.bumpDown()
      @


    # ----------------------------------------------------- UI Events
    onProceedClick: ->
      unless @i + 1 is @collection.length
        @_next()
      else
        @_finish()

    close: ->
      $(window).off 'keydown'
      @


  Export


