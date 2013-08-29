define [
  'underscore'
  'backbone'
],
(
  _
  Backbone
) ->


  STATES =
    pending: 'pending'
    done: 'done'
    error: 'error'


  Export = Backbone.Model.extend

    # Overridable defaults for this base class
    maxPolls: 10 # Poll limit, time out after this
    pollWait: 500 # Time to wait between polls

    initialize: (options) ->
      _.bindAll @, 'onGotStarted', 'onPromiseFail', '_poll'
#      console.log
#        this:@
#        options:options

    fetch: ->
      url = _.result @, 'url'
      console.error "Need a url" unless url
      promise = $.get url
      promise.done @onGotStarted
      promise.fail @onPromiseFail
      @


    # ----------------------------------------------------------- Callbacks
    onGotStarted: (resp, httpStatus, xhr) ->
#      console.log
#        resp:resp
#        httpStatus:httpStatus
      console.error "response doesn't include a link" unless resp.status.link?
      @polls = 0
      @_poll resp

    onPromiseFail: (jqXHR, textStatus, errorThrown) ->
      @trigger 'error', @, textStatus, { jqXHR:jqXHR, textStatus:textStatus, errorThrown:errorThrown }


    # ----------------------------------------------------------- Private
    _poll: (resp) ->
#      console.log resp:resp
      switch resp.status.state
        when STATES.pending
          if @polls >= @maxPolls
            @trigger 'error', @, 'Timed out polling for progress'
          else
            @polls++
            promise = $.get resp.status.link
            promise.done (resp) => setTimeout (=> @_poll resp), @pollWait
            promise.fail @onPromiseFail
        when STATES.done
          @trigger 'sync', @, "Progress completed"
#          console.log resp:resp
        when STATES.error
          @trigger 'error', @, "Error polling for progress"
        else
          console.warn "unknown poll state"


    # ----------------------------------------------------------- Public



  Export

