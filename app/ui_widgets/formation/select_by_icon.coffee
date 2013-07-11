define [
  'jquery'
  'backbone'
  'Handlebars'
  'text!./select_by_icon.hbs'
], (
  $
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'ui_widgets/formation/select_by_icon'
  _tmpl = Handlebars.compile tmpl
  _selectedClass = 'active'
  _btnHolderSel = '.purdyBts'

  Me = Backbone.View.extend
    className: 'field selectByIcon'
    events:
      'click .btn': 'onBtnClick'
      'change select': 'onSelectChange'

    initialize: ->
      @$el.addClass @model.attributes.string_id

    render: ->
      @$el.html _tmpl @model.attributes
      @$(_btnHolderSel).css('display': 'inline-block') #.show() uses inline, which is no good
      @$('select').hide()
      @

    _syncSelectByBtn: ->
      selectedVals = []
      @$('button').each ->
        if $(this).hasClass _selectedClass
          selectedVals.push $(this).val()
      @$('select').val selectedVals
      @model.set 'value', @$('select').val()
      @$('select').trigger 'change'

    _syncBtnBySelect: ->
      selectedVal = @$('select').val()
#      console.log selectedVal:selectedVal
      # Highlight the button if the values match, or if the button is one of multiple selected values
      @$('button').each ->
        $(this).removeClass _selectedClass
        if _.isArray(selectedVal)
          if _.contains selectedVal, $(this).val()
            $(this).addClass _selectedClass
        else
          if $(this).val() is selectedVal
            $(this).addClass _selectedClass

    onBtnClick: (e) ->
      $targ = $(e.currentTarget)
      clickedVal = $targ.val()
      $targ.toggleClass _selectedClass
      if $targ.hasClass _selectedClass
        unless @model.attributes.multiselect
          $targ.siblings(".#{_selectedClass}").removeClass _selectedClass
      @_syncSelectByBtn()

    onSelectChange: (e) ->
      @_syncBtnBySelect()
      @trigger 'change',
        model: @model
        value: @$('select').val()


  Me

