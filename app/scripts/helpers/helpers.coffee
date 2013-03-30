define [
  'jquery'], ($) ->

  Helpers = 
    getQueryParam: (param) ->
      query = window.location.search.substring(1)
      qParams = query.split("&")
      for qParam in qParams
        pair = qParam.split("=")
        if pair[0] == param
          return unescape(pair[1])
      return false

  Helpers
