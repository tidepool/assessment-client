define [
  'underscore'
  './numbers'
],
(
  _
  numbers
) ->
  describe 'numbers', ->

    describe 'numbers.flipCoin', ->
      it 'has an .flipCoin method', ->                      expect(numbers.flipCoin).toBeDefined()
      it 'returns either true or false', ->                 expect(typeof numbers.flipCoin()).toEqual('boolean')

    describe 'numbers.casino', ->
      it 'has an .casino method', ->                        expect(numbers.casino).toBeDefined()
      it 'returns either true or false', ->                 expect(typeof numbers.casino()).toEqual('boolean')
      it 'accepts a decimal from 0-1 representing odds', -> expect(typeof numbers.casino(0.25)).toEqual('boolean')
      it '1 is 100%, so always true', ->                    expect(typeof numbers.casino(1)).toBeTruthy()
