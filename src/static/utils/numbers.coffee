define [], () ->


  # Utility Methods for working with numbers
  numbers =

    # Return true or false. A coin flip.
    flipCoin: -> !! Math.floor(Math.random()*2)

    # Send a number between 0 and 1 representing the percentage odds you'd like
    # Returns true or false
    casino: (odds) ->
      odds = odds || 0.5 # 50% chance by default
      !! ( odds > Math.random() ) # Are odds less than a random number between 0 and 1?

    # Picks a random element from an array
    pickOneAnyOne: (array) -> array[Math.floor(Math.random()*array.length)]

  numbers
