class InputHealth.ErrorHandler
  error_storage: null
  constructor: (options = {})->
    @_init_error_storage options

  process: (xhr) ->
    before_callback  = xhr.ajax_settings.beforeSend
    success_callback = xhr.ajax_settings.success
    error_callback   = xhr.ajax_settings.error

    xhr.ajax_settings.beforeSend = =>
      xhr.ajax_settings.retry_before() if xhr.ajax_settings.retry_before instanceof Function
      before_callback.apply(xhr.ajax_settings.beforeSend.caller, arguments)

    xhr.ajax_settings.success = =>
      xhr.ajax_settings.retry_success() if xhr.ajax_settings.retry_success instanceof Function
      success_callback.apply(xhr.ajax_settings.success.caller, arguments)

    xhr.ajax_settings.error = =>
      xhr.ajax_settings.retry_error() if xhr.ajax_settings.retry_error instanceof Function
      error_callback.apply(xhr.ajax_settings.error.caller, arguments)

    @last_error_id = @error_storage.add xhr
    @render_error xhr

  retry: (error_xhr_id, callbacks = {}) ->
    error_xhr_id = error_xhr_id || @last_error_id
    xhr = @error_storage.get error_xhr_id
    @error_storage.remove error_xhr_id
    xhr.ajax_settings.retry_success = callbacks.success
    xhr.ajax_settings.retry_before  = callbacks.beforeSend
    xhr.ajax_settings.retry_error   = callbacks.error
    $.ajax xhr.ajax_settings


  render_error: (xhr) ->
    try
      @["render_#{xhr.status}"] xhr
    catch e
      console.error "No action for #{xhr.status} status."
      @render_general xhr

  render_general: (error) -> null

  _init_error_storage: (options) ->
    @error_storage = options.error_storage || new InputHealth.ErrorStorage