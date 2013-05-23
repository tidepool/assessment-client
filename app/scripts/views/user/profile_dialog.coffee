define [
  'jquery'
  'underscore'
  'Backbone'
  'Handlebars'
  "text!./profile_dialog.hbs"
],
(
  $
  _
  Backbone
  Handlebars
  tmpl
) ->

  _me = 'views/user/profile_dialog'

  ProfileDialog = Backbone.View.extend
    className: 'profileDialog modal small hide fade'
    events:
      "submit form": "submitProfile"

    # ----------------------------------------------------------- Backbone Methods
    initialize: (options) ->
      @user = options.user
      @_registerHandlebarsHelpers()
      @tmpl = Handlebars.compile tmpl
      @render()

    render: ->
      @$el.html @tmpl @getTemplateData()
      @


    # ----------------------------------------------------------- Custom / Helper Methods
    _registerHandlebarsHelpers: ->
      Handlebars.registerHelper 'isMale', (gender) =>
        return "checked" if gender is 'male' 
      Handlebars.registerHelper 'isFemale', (gender) =>
        return "checked" if gender is 'female'

    getTemplateData: ->
      user = 
        name: @user.get('name')
        email: @user.get('email')
        imageUrl: @user.get('image')
        dob: @user.get('date_of_birth')
        gender: @user.get('gender')
        timezone: @user.get('timezone')
        city: @user.get('city')
        state: @user.get('state')
        country: @user.get('country')

    getNewValues: ->
      @user.set
        name: $('#name').val()
        email: $('#email').val()
        date_of_birth: $('#dob').val()
        gender: $('#gender').val()
        timezone: $('#timezone').val()
        city: $('#city').val()
        state: $('#state').val()
        country: $('#country').val()


    # ----------------------------------------------------------- Event Handlers
    submitProfile: (e) ->
      e.preventDefault()
      @getNewValues()
      @user.save()
      .done =>
        console.log("Profile changes saved")
      .fail =>
        console.log("Error saving changes")


    # ----------------------------------------------------------- Public API
    show: -> @$el.modal('show')
    close: -> @$el.modal('hide')


  ProfileDialog
