define [
  'jquery'
  'Backbone'
  'Handlebars'
  "text!./psst.hbs"
],
(
  $
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'ui_widgets/psst'
  _TYPES =
    good: 'good'
    info: 'info'
    question: 'question'
    warn: 'warn'
    error: 'error'
  _defaultType = _TYPES.info
  _className = 'psst'

  Me = Backbone.View.extend
    tagName: 'aside'
    className: "#{_className} alert" #leveraging some of bootstrap's alert styling here

    initialize: ->
      @tmpl = Handlebars.compile tmpl

    render: (opts) ->
      throw new Error('Need .msg and .sel') unless opts.msg and opts.sel
      options =
        title: opts.title || null
        msg: opts.msg
        type: opts.type || _defaultType
        selector: opts.sel
      @$el.html @tmpl options
      @$el.attr 'class', "#{@className} #{options.type}"
      @$el.clone().prependTo options.selector
      @

    _hide: ->
      return unless @$el.is(':visible')
      @$el
        .attr('class', @className)
        .remove()

    _hideAll: ->
      $(".#{_className}").remove()


  # Publicize a singleton's render method and mix in some additional helpers
  me = new Me()
  me.render = _.bind me.render, me
  me.render.hide = _.bind me._hideAll, me
  me.render.TYPES = _TYPES
  me.render

