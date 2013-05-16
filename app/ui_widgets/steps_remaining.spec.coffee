define [
  './steps_remaining'
],
(
  StepsRemaining
) ->

  describe 'ui_widgets/steps_remaining', ->

    _step1 =
      isComplete: true
      friendly_name: "Step 1"
      instructionsBrief: "To complete this step you should..."
    _step2 =
      isComplete: true
      friendly_name: "Step 2"
      instructionsBrief: _step1.instructionsBrief
    _step3 =
      isComplete: false
      friendly_name: "Step 3"
      instructionsBrief: _step1.instructionsBrief
    _steps = [ _step1, _step2, _step3 ]

    beforeEach ->
      jasmine.getFixtures().set sandbox() # Set up an empty #sandbox div that gets cleaned up after every test

    it 'Exists', ->
      expect(StepsRemaining).toBeDefined()

    it 'Has access to a fixture #sandbox through the jasmine-jquery plugin', ->
      expect(jasmine.Fixtures).toBeDefined()
      expect(sandbox).toBeDefined()
      expect($('#sandbox')).toHaveLength(1)

    it 'Requires a collection in order to be created', ->
      expect(
        -> new StepsRemaining() # An anonymous function wrapper is required when asserting .toThrow: http://stackoverflow.com/questions/4144686/how-to-write-a-test-which-expects-an-error-to-be-thrown
      ).toThrow('Need a collection to build a stepsRemaining view')
      steps = new StepsRemaining
        collection: new Backbone.Collection
      expect(steps).toBeInstanceOf(StepsRemaining)

    it 'Can create markup with both complete and incomplete steps', ->
      steps = new StepsRemaining
        collection: new Backbone.Collection _steps
      $sandbox = $('#sandbox')
      expect( $sandbox ).toBeEmpty()
      steps.render().$el.appendTo '#sandbox'
      expect( $sandbox ).not.toBeEmpty()

      $steps = $sandbox.find(".stepsRemaining")
      expect($steps).toHaveLength(1)
      expect($steps.find('.step')).toHaveLength(3) # Test data has 3 steps
      expect($steps.find('.step.completed')).toHaveLength(2) # Test data has 2 complete steps

