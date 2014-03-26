class InputHealth.XHRPool
  constructor: (objects, options) ->
    @error_handler = options.error_handler
    @xhrs = objects || []

  add: (xhr)->
    @xhrs.push xhr

  remove: (xhr) ->
    @xhrs = _(@xhrs).reject (obj) -> obj is xhr


  pause: ->
    _(@xhrs).each (xhr) ->
      xhr.abort()
      xhr.aborted = true

    @xhrs = []

  resume: ->
    _(@error_handler.error_storage.errors).each (xhr, id) =>
      @error_handler.retry id if xhr.aborted
