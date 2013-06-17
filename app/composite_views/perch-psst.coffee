

define [
  'jquery'
  'backbone'
  'Handlebars'
  "./perch"
],
(
  $
  Backbone
  Handlebars
  perch
) ->

  _me = 'composite_views/perch-psst'
  _contentSel = '#PerchBody'
  _iconTmpl = Handlebars.compile '
    <p class="row">
      <i class="icon-2x {{icon}}"></i>
    </p>
  '


  Me = perch.Klass.extend

    _showOptionsObject: (options) ->
      options.content = ''
      if options.icon
        options.content += _iconTmpl options
      if options.msg
        options.content += "<p class='large'>#{options.msg}</p>"

      options.content = "<div class='highlight'>#{options.content}</div>"

      @model.set options
      @_bindDomEvents()
      dropStyle = if options.mustUseButton then 'static' else true
      @$el.modal
        backdrop: dropStyle

      #$(_contentSel).addClass 'highlight'

  new Me()

