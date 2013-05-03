define [
  'jquery',
  'underscore',
  'Backbone',
  'Handlebars',
  "text!./profile_dialog.hbs"], ($, _, Backbone, Handlebars, tempfile) ->
  ProfileDialog = Backbone.View.extend  
    events:
      "click #addFacebook": "addFacebook"
      "click #addTwitter": "addTwitter"
      "click #addFitbit": "addFitbit"
      "click #removeFacebook": "removeFacebook"
      "click #removeTwitter": "removeTwitter"
      "click #removeFitbit": "removeFitbit"
      "submit #profileForm": "submitProfile"

    initialize: (options) ->
      @user = options.user
      @listenTo(@user, 'user:authentication_added', @authenticationAdded)
      @registerHandlebarsHelpers()

    registerHandlebarsHelpers: ->
      Handlebars.registerHelper 'isMale', (gender) =>
        return "checked" if gender is 'male' 
      Handlebars.registerHelper 'isFemale', (gender) =>
        return "checked" if gender is 'female' 
    
    enableDisableAvailableAuthentications: ->
      providers = ['facebook', 'fitbit', 'twitter']
      for provider in providers
        authExists = @authExists(provider)
        # Capitalize it
        provider = provider.charAt(0).toUpperCase() + provider.slice(1)
        addSelector = "#add#{provider}"
        removeSelector = "#remove#{provider}"
        if authExists
          $(@el).find(addSelector).prop('disabled', true)
          $(@el).find(removeSelector).prop('disabled', false)
        else
          $(@el).find(addSelector).prop('disabled', false)
          $(@el).find(removeSelector).prop('disabled', true)

    authExists: (provider) ->
      for auth in @user.get('authentications')
        if provider is auth.provider
          return true
      return false

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

    render: ->
      template = Handlebars.compile(tempfile)
      $(@el).html(template( { user: @getTemplateData() } ))
      @enableDisableAvailableAuthentications()
      this

    show: ->
      $("#messageView").html(@render().el)
      $("#profile-dialog").modal('show')

    close: -> 
      $("#profile-dialog").modal('hide')

    authenticationAdded: (provider) ->
      @user.fetch()
      .done (data, textStatus, jqXHR) =>
        console.log("Updated user info")
        @render()
      .fail (jqXHR, textStatus, errorThrown) =>
        console.log("Cannot refresh user info")

    addFacebook: (e) ->
      e.preventDefault()
      @user.addAuthentication('facebook', {width: 1006, height: 775})

    addTwitter: (e) ->
      e.preventDefault()
      @user.addAuthentication('twitter', {width: 1006, height: 775})

    addFitbit: (e) ->
      e.preventDefault()
      @user.addAuthentication('fitbit', {width: 1006, height: 775})

    removeFacebook: (e) ->
      e.preventDefault()

    removeTwitter: (e) ->
      e.preventDefault()

    removeFitbit: (e) ->
      e.preventDefault()

    submitProfile: (e) ->
      e.preventDefault()
      @getNewValues()
      @user.save()
      .done =>
        console.log("Profile changes saved")
      .fail =>
        console.log("Error saving changes")

    getNewValues: ->
      # TODO: Consider using some databinding library
      # rivets.js, etc.
      @user.set
        name: $('#name').val()
        email: $('#email').val()
        date_of_birth: $('#dob').val()
        gender: $('#gender').val()
        timezone: $('#timezone').val()
        city: $('#city').val()
        state: $('#state').val()
        country: $('#country').val()

  ProfileDialog
