define [
  'jquery'
  'backbone'
  'Handlebars'
  'text!./select_by_icon.hbs'
], (
  $
  Backbone
  Handlebars
  tmplSelectByIcon
) ->

  _tmplSelectByIcon = Handlebars.compile tmplSelectByIcon
  _valueToIcon =
    left: 'gfx-lefthand'
    right: 'gfx-righthand'
    male: 'gfx-male'
    female: 'gfx-female'
  _selectedClass = 'active'
  _btnHolderSel = '.purdyBts'

  Me = Backbone.View.extend
    className: 'field selectByIcon'
    events:
      'click .btn': 'onBtnClick'

    initialize: ->
      @_mapValuesToIcons()
      @$el.addClass @model.attributes.string_id

    render: ->
      @$el.html _tmplSelectByIcon @model.attributes
      @$(_btnHolderSel).show()
      @$('select').hide()
      @

    _mapValuesToIcons: ->
      options = []
      for value, i in @model.get 'options'
        icon = _valueToIcon[ value.toLowerCase() ]
        options.push
          value: value
          icon: icon || "icon-#{value}"
      @model.set 'options', options

    _syncVal: ->
      selectedVals = []
      @$('button').each ->
        if $(this).hasClass _selectedClass
          selectedVals.push $(this).val()
      @$('select').val selectedVals
      @model.set 'value', @$('select').val()
      @$('select').trigger 'change'

    onBtnClick: (e) ->
      $targ = $(e.currentTarget)
      clickedVal = $targ.val()
      $targ.toggleClass _selectedClass
      if $targ.hasClass _selectedClass
        unless @model.attributes.multiselect
          $targ.siblings(".#{_selectedClass}").removeClass _selectedClass
      @_syncVal()



  Me