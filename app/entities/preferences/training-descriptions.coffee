
define [
  'classes/collection'
],
(
  Collection
) ->

  Export = Collection.extend
    url: -> "#{window.apiServerUrl}/api/v1/preferences/training-preference/description"

#    parse: (resp) ->
#      return null unless resp
#      # Merge stored field values with field descriptions
#      fields = resp.description
#      for field in fields
#        field.value = resp.data[field.name]
#      @fields = new Preferences fields
#      @

    # ----------------------------------------------- Consumable API
    # Provides an easy way to set the values of the fields in this collection
    setValues: (values) ->
      return @ unless values
#      console.log trainingModel: values
      for key, val of values
        model = @find (model) -> model.attributes.name is key
        model.set value:val if model?
#      console.log collection:@toJSON()
      @


    # Pull out a name value hash of the fields represented in this collection
    getValues: -> console.warn 'not implemented'

  Export


