define [
  './circles'
],
(
  Circles
) ->

  _data = [
    { size: 2 }
    { size: 2 }
    { size: 2 }
    { size: 2 }
    { size: 2 }
  ]

  _szPercentMappings =
    '0': 0
    '10': 0
    '19': 0
    '20': 1
    '39': 1
    '40': 2
    '50': 2
    '59': 2
    '70': 3
    '90': 4
    '99': 4
    '100': 4

  describe 'entities/circles', ->
    circles = null

    beforeEach -> circles = new Circles _data

    it 'exists', ->                           expect(circles).toBeDefined()
    it 'is instantiated with data', ->        expect(circles.length).toEqual _data.length

    describe '_setSizeByPercent', ->
      circle = null
      beforeEach -> circle = circles.at(0)
      it 'is defined', ->                     expect(circle._setSizeByPercent).toBeDefined()
      it 'calculates expected sizes', ->
        for key, val of _szPercentMappings
          expect(circle._setSizeByPercent(key).get('size')).toEqual _szPercentMappings[key]

