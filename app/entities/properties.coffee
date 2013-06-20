define [
  'backbone'
],
(
  Backbone
) ->

  _me = 'entities/properities'
  _TYPES =
    selectByIcon: 'select_by_icon'
    dob: 'dob'
    email: 'email'
    password: 'password'
    search: 'search'
    url: 'url'
    tel: 'tel'
    number: 'number'
    range: 'range'
    date: 'date'
    time: 'time'
    color: 'color'
    text: 'text'
    select: 'select'
  _capFirstLetter = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)



  OneProperty = Backbone.Model.extend
    # String ID is required. All the rest are optional
    defaults:
      string_id: null
      label: null
      type: _TYPES.text
      required: null
      value: null
      multiSelect: null # applies to select boxes -- should we let them pick more than one?
      #validationRegex: null # if set, field must pass this to validate
      #minLength: null # set to require a certain number of chars

    initialize: ->
      @_calculateLabel()
      @on 'change:label', @_calculateLabel

    _calculateLabel: ->
      if @get 'label'
        lbl = @get('label')
      else
        lbl = _capFirstLetter @get('string_id')
      @set
        label: lbl,
      {silent: true}


  Collection = Backbone.Collection.extend
    model: OneProperty
  Collection.TYPES = _TYPES # Publicize


  Collection


