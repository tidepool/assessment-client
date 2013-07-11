define [
  'backbone'
  'ui_widgets/formation/select_by_icon'
],
(
  Backbone
  SelectByIcon
) ->


  # --------------------------------------------------------------------- Fixture
  _minData =
    string_id: 'genderSimple'
    options: [
      { value: 'female' }
      { value: 'male' }
    ]
  _fullData =
    string_id: 'gender'
    type: 'select_by_icon'
    label: 'Sex'
    multiselect: true
    options: [
      { value:'female', label:'A Girl', icon:'gfx-female' }
      { value:'male', label:'A Boy', icon:'gfx-male' }
    ]
  _factory = (data) ->
    new SelectByIcon
      model: new Backbone.Model data


  # --------------------------------------------------------------------- Helpers
  _valByName = (name) ->
    $('#sandbox').find("input[name='#{name}']").val()


  # --------------------------------------------------------------------- Specs
  beforeEach ->
    jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test


  describe 'ui_widgets/formation/select_by_icon', ->

    it 'exists', ->
      expect(SelectByIcon).toBeDefined()


    describe 'builds a UI control based on options', ->

      it 'creates expected content when given minimum data', ->
        view = _factory _minData
        $('#sandbox').append view.render().el
        expect($('#sandbox')).toContain(".selectByIcon")
        expect($('#sandbox')).toContainText(_minData.options[0].value)
        expect($('#sandbox')).toContain(".#{_minData.string_id}")

      it 'creates expected content when given more detailed data', ->
        view = _factory _fullData
        $('#sandbox').append view.render().el
        expect($('#sandbox')).toContain(".#{_fullData.string_id}")


    describe 'has extra, optional fields', ->

      it 'is single-select by default', ->
        view = _factory _minData
        $('#sandbox').append view.render().el
        expect($('#sandbox .selectByIcon select[multiple]')).toHaveLength 0
        expect($('#sandbox .selectByIcon select')).toHaveLength 1

      it 'can be multi-select', ->
        view = _factory _fullData
        $('#sandbox').append view.render().el
        expect($('#sandbox .selectByIcon select[multiple]')).toHaveLength 1

      it 'supports an optional `label` property', ->
        view = _factory _fullData
        $('#sandbox').append view.render().el
        expect($('#sandbox .selectByIcon')).toContain("label")


#    describe 'it changes the value of a hidden select input based on clicking the buttons', ->




