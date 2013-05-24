
define ['jquery'],($) ->

  _me = 'bower_components_ext/bootstrap_buttons-radio'
  _radioGroupSel = '[data-toggle="buttons-radio"]'

  # Set the value of the hidden input to the value of the .active button. If there is no value on the active button, use the text.
  setHiddenValue = ($radioGroup) ->
    $group = $radioGroup || $(_radioGroupSel)
    newVal = $group.find('.active').val()
    newVal = newVal || $group.find('.active').text().toLowerCase().split(' ').join('')
    $hiddenInput = $group.find('input[type="hidden"]:first')
    $hiddenInput.val newVal
    #$hiddenInput.trigger('change')
    #console.log "#{_me}.setHiddenValue() to #{newVal}"

  $('body').delegate _radioGroupSel, 'click', ->
    setTimeout =>
      setHiddenValue $(this)
    , 5 # The delay allows bootstrap to fire its event before we check up on it

  setHiddenValue
