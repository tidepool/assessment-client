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
  _iconTmpl = ""

  Me = perch.Klass.extend

    _showOptionsObject: (options) ->
      if options.msg
        options.content = "<p>#{options.msg}</p>"
      @model.set options
      @_bindDomEvents()
      dropStyle = if options.mustUseButton then 'static' else true
      @$el.modal
        backdrop: dropStyle


  new Me()