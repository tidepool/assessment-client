define [
  'backbone'
  'Handlebars'
  'entities/properties'
  'syphon'
  './select_by_icon'
  'text!./standard_field.hbs'
  'text!./select_field.hbs'
  'text!./dob_field.hbs'
], (
  Backbone
  Handlebars
  Properties
  Syphon
  SelectByIcon
  tmplStandardField
  tmplSelectField
  tmplDOB
) ->

  _tmplStandardField = Handlebars.compile tmplStandardField
  _tmplSelectField = Handlebars.compile tmplSelectField
  _tmplDOB = Handlebars.compile tmplDOB

  Me = Backbone.View.extend
    tagName: 'form'
    className: 'formation clearfix'

    initialize: ->
      return unless @options.data
      @collection = new Properties @options.data

    render: ->
      @$el.empty()
      @collection.each (prop) => @$el.append @_renderProperty prop
      @

    _renderProperty: (prop) ->
      types = Properties.TYPES
#      console.log
#        properties: Properties
#        ptext: Properties.TYPES
      switch prop.get 'type'
        when types.select
          _tmplSelectField prop.attributes
        when types.selectByIcon
          view = new SelectByIcon model:prop
          view.render().el
        when types.dob
          _tmplDOB prop.attributes
        else
          _tmplStandardField prop.attributes

#    onChange: (model) ->
#      formData = Syphon.serialize @el
#      console.log
#        collection: model.collection.toJSON()
#        formData: formData


    # ---------------------------------------------------------------- Public API
    getVals: ->
      formData = Syphon.serialize @el
      # remove field names for blank values
      for field, val of formData
        delete formData[field] unless val
#      console.log formData:formData
      formData

    setVals: ->
      # TODO: set values in the form based on an input name/value pair



  Me


