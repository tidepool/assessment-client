define [
  'backbone'
  'ui_widgets/formation'
],
(
  Backbone
  Formation
) ->


  _myClassName = '.formation'


  # --------------------------------------------------------------------- Fixture
  _fieldSmpl =
    string_id: 'first_name'
  _fieldWithLabel =
    string_id: 'last_name'
    label: 'Last Name'
  _fieldDate =
    string_id: 'dob'
    type: 'date'
    label: 'Birthdate'
  _fieldSelect =
    string_id: 'education'
    type: 'select'
    label: 'Education'
    options: [
      'Some Elementary School'
      'Some High School'
      'Some College'
      'PhilzDoctor'
    ]
  _fieldSelByIcon =
    string_id: 'gender'
    type: 'select_by_icon'
    label: 'Sex'
    multiselect: false
    options: [
      'Female'
      'Male'
    ]
  _formData = [ _fieldSmpl, _fieldDate, _fieldSelect, _fieldSelByIcon ]


  # --------------------------------------------------------------------- Specs
  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test


  describe 'ui_widgets/formation', ->

    it 'exists', ->
      expect(Formation).toBeDefined()

    it 'Requires a `data` option', ->
      expect( -> new Formation()).toThrow()
      formation = new Formation
        data: [ _fieldSmpl ]
      expect(formation).toBeInstanceOf(Backbone.View)

    it 'Given an array of objects, each with a `string_id` property, form fields will be created', ->
      formation = new Formation
        data: [ _fieldSmpl, _fieldSmpl ]
      $('#sandbox').html formation.render().el
      expect( $('#sandbox') ).toContain 'input'
      expect( $('#sandbox input') ).toHaveLength 2

    it 'can create select fields', ->
      formation = new Formation
        data: [ _fieldSelect ]
      $('#sandbox').html formation.render().el
      expect( $('#sandbox') ).toContain 'select'

    it 'Accepts a label property', ->
      formation = new Formation
        data: [ _fieldWithLabel ]
      $('#sandbox').html formation.render().el
      expect( $('#sandbox') ).toContain 'input'
      expect( $('#sandbox') ).toContain 'label'
      expect( $('#sandbox label') ).toHaveLength 1
      expect( $('#sandbox label') ).toContainText _fieldWithLabel.label

#    it 'Accepts a placeholder property', ->
#    it 'Accepts a type property', ->
#    it 'provides values using .getVals()', ->


    it 'Optionally creates a submit button', ->
      formation = new Formation data:_formData
      $('#sandbox').html formation.render().el

    it 'does not add any button by default', ->
      formation = new Formation data:_formData
      $('#sandbox').html formation.render().el
      expect( $('#sandbox')).not.toContain 'button[type=submit]'

    it 'adds a button if passed `true`', ->
      formation = new Formation
        data:_formData
        submitBtn: true
      $('#sandbox').html formation.render().el
      expect( $('#sandbox')).toContain 'button[type=submit]'

    it 'allows you to set css classes on it', ->
      formation = new Formation
        data:_formData
        submitBtn:
          className: 'btn-large btn-inverse'
      $('#sandbox').html formation.render().el
      expect( $('#sandbox').find('.btn-inverse') ).toHaveLength 1

    it 'defaults to `save` if no text is provided', ->
      formation = new Formation
        data:_formData
        submitBtn: true
      $('#sandbox').html formation.render().el
      expect( $('#sandbox button[type=submit]') ).toContainText 'Save'

    it 'allows you to specify the button text', ->
      txt = 'Make Rainbows'
      formation = new Formation
        data:_formData
        submitBtn: text:txt
      $('#sandbox').html formation.render().el
      expect( $('#sandbox button[type=submit]') ).toContainText txt









