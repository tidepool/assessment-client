define [
  'backbone'
  'Handlebars'
  'entities/properties'
  'syphon'
  './select_by_icon'
  'text!./standard_field.hbs'
  'text!./select_field.hbs'
  'text!./date_field.hbs'
  'text!./button.hbs'
  'text!./rocker.hbs'
  'text!./checkbox.hbs'
], (
  Backbone
  Handlebars
  Properties
  Syphon
  SelectByIcon
  tmplStandardField
  tmplSelectField
  tmplDate
  tmplBtn
  tmplRocker
  tmplCheckbox
) ->

  _tmplStandardField = Handlebars.compile tmplStandardField
  _tmplSelectField = Handlebars.compile tmplSelectField
  _tmplDate = Handlebars.compile tmplDate
  _tmplBtn = Handlebars.compile tmplBtn
  _tmplRocker = Handlebars.compile tmplRocker
  _tmplCheckbox = Handlebars.compile tmplCheckbox

  Me = Backbone.View.extend
    tagName: 'form'
    className: 'formation clearfix'

    initialize: ->
      throw new Error 'Need options.data' unless @options.data
      @collection = new Properties @options.data

    render: ->
      @$el.empty()
      @collection.each (prop) => @$el.append @_renderProperty prop
      if @options.submitBtn?
        @$el.append _tmplBtn @options.submitBtn
      if @options.values?
        @setVals @options.values
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
        when types.date
          _tmplDate prop.attributes
        when types.rocker
          _tmplRocker prop.attributes
        when types.checkbox
          _tmplCheckbox prop.attributes
        else
          console.log "Building a standard form field for type #{prop.get 'type'}"
          _tmplStandardField prop.attributes


    # ---------------------------------------------------------------- Public API
    getVals: ->
      formData = Syphon.serialize @el
      # remove field names for blank values
      for field, val of formData
        delete formData[field] unless val? # Deletes the property if it is undefined or null. False is preserved
#        if val.length is 1 and not val[0] # remove blank arrays (a quirk of unselected multiselect boxes
#          delete formData[field]
#      console.log formData:formData
      formData

    setVals: (newValues) ->
#      console.log
#        newValues: newValues
#      for name, value of newValues
#        $field = @$("[name=#{name}]")
#        if $field?.length
#          console.log field:$field
#          $field.val value
      Syphon.deserialize @el, newValues
      @$('select').trigger 'change' # Otherwise setting values doesn't trigger this event
      @




  Me


