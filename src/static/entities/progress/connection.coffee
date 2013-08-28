define [
  './_base'
],
(
  ProgressModel
) ->

  Export = ProgressModel.extend

    url: -> "#{window.apiServerUrl}/api/v1/users/-/connections/#{@attributes.provider}/synchronize"


    # ----------------------------------------------------------- Public


  Export

