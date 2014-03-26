class InputHealth.AjaxHandler
  constructor: (options = {}) ->
    @error_handler = options.error_handler
    @server_url    = if options.server_url then options.server_url else ''

    @xhr_pool = new InputHealth.XHRPool [], error_handler: @error_handler

  for: (type, options = {})-> @["#{type}_callbacks"] options

  pause: -> @xhr_pool.pause()
  resume: -> @xhr_pool.resume()

  before: ->
  success: ->
  error: ->


  backbone_callbacks: (options) ->
    raw_callbacks = @make_raw_callbacks options

    callbacks =
      beforeSend: (xhr, ajax_settings) =>
        @before arguments
        ajax_settings.url = @server_url + ajax_settings.url unless /^http/.test ajax_settings.url
        xhr.ajax_settings = ajax_settings
        console.log ajax_settings.url
        @xhr_pool.add xhr
        @apply_callback raw_callbacks.beforeSend, arguments

      success: (model_or_collection, xhr, options) =>
        @success arguments
        @xhr_pool.remove options.xhr
        @apply_callback raw_callbacks.success, arguments

      error:  (model_or_collection, xhr, options) =>
        @error arguments
        @xhr_pool.remove xhr
        @error_handler.process xhr
        @apply_callback raw_callbacks.error, arguments unless xhr.no_error_callback

    @merge_processed_callbacks options, callbacks


  jquery_callbacks: (options) ->
    raw_callbacks = @make_raw_callbacks options

    callbacks =
      beforeSend: (xhr, ajax_settings) =>
        @before arguments
        ajax_settings.url = @server_url + ajax_settings.url unless /^http/.test ajax_settings.url
        xhr.ajax_settings = ajax_settings
        console.log ajax_settings.url
        @xhr_pool.add xhr
        @apply_callback raw_callbacks.beforeSend, arguments


      success: (data, text_status, xhr) =>
        @success arguments
        @xhr_pool.remove xhr
        @apply_callback raw_callbacks.success, arguments

      error: (xhr, text_status, error_thrown) =>
        @error arguments
        @xhr_pool.remove xhr
        @error_handler.process xhr
        @apply_callback raw_callbacks.error, arguments unless xhr.no_error_callback

    @merge_processed_callbacks options, callbacks

  simple_callbacks: (options) ->
    raw_callbacks = @make_raw_callbacks options

    callbacks =
      beforeSend: (xhr, ajax_settings) =>
        @before arguments
        ajax_settings.url = @server_url + ajax_settings.url unless /^http/.test ajax_settings.url
        xhr.ajax_settings = ajax_settings
        console.log ajax_settings.url
        @xhr_pool.add xhr
        @apply_callback raw_callbacks.beforeSend, arguments

      success: (data, text_status, xhr) =>
        @success arguments
        @xhr_pool.remove xhr
        @apply_callback raw_callbacks.success, arguments

      error: (xhr, text_status, error_thrown) =>
        @error arguments
        @xhr_pool.remove xhr
        @error_handler.error_storage.add xhr
        @apply_callback raw_callbacks.error, arguments unless xhr.no_error_callback

    @merge_processed_callbacks options, callbacks

  micro_callbacks: (options) ->
    raw_callbacks = @make_raw_callbacks options

    callbacks =
      beforeSend: (xhr, ajax_settings) =>
        @before arguments
        ajax_settings.url = @server_url + ajax_settings.url unless /^http/.test ajax_settings.url
        @apply_callback raw_callbacks.beforeSend, arguments

      success: (data, text_status, xhr) =>
        @success arguments
        @apply_callback raw_callbacks.success, arguments

      error: (xhr, text_status, error_thrown) =>
        @error arguments
        @apply_callback raw_callbacks.error, arguments

    @merge_processed_callbacks options, callbacks


  apply_callback: (callback, args) ->
    callback.apply callback.caller, args if callback instanceof Function


  make_raw_callbacks: (options) ->
    if options.before instanceof Function
      options.beforeSend = options.before
      delete options.before

    beforeSend: options.beforeSend
    success:    options.success
    error:      options.error


  merge_processed_callbacks: (options, callbacks) ->
    output = _.defaults(callbacks, options)
    output.xhr = ->
      xhr = jQuery.ajaxSettings.xhr()
      xhr.upload.addEventListener("progress", options.progress ,false) if xhr.upload
      xhr

    output