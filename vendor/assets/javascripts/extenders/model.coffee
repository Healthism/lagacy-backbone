class InputHealth.Model extends Backbone.Model

  is_synced: false
  class_name: 'A Model'

  options: {}

  after_sync: ->
    @after_sync_callbacks ||= []
    _(arguments).each (callback) => @after_sync_callbacks.push callback

  constructor: (attributes = {} , options = {}) ->

    @options = _.defaults options, @options
    @class_name = @__proto__?.constructor.name || @class_name

    super attributes, options

    @paramRoot = options.paramRoot if options.paramRoot
    @urlRoot = options.urlRoot if options.urlRoot

    @url = attributes.url || @url
    delete @attributes.url

    @app = @collection?.app || options.app

    @on 'sync', @_run_after_sync_callbacks, this

  as_json: -> _.clone(@attributes)
  toJSON: (options) -> @_wrap_param_root _.clone(@attributes)

  fetch: (options = {}) ->
    options = _.defaults @_define_callbacks('load', options), @options.callbacks
    super options

  unset_attributes: (attributes, options) ->
    _.each attributes, (a) => @unset a, silent: true
    @trigger 'change' unless options.silent

  is_loaded: -> if typeof(@attributes.name) is 'string' or typeof(@attributes.title) is 'string' then true else false

  on: (event, callback, context = window, smart = true ) ->
    @off event, callback if smart
    super(event, callback, context)

  once : (ev, callback, context) ->
    onceFn = =>
      @off(ev, onceFn)
      callback.apply context || this, arguments

    @on(ev, onceFn)
    return this

  _run_after_sync_callbacks: ->
    if @after_sync_callbacks
      _(@after_sync_callbacks).each (callback) => callback.call this
    else
      @off 'sync', @_run_after_sync_callbacks,

  _mark_as_synced: ->
    @is_synced = true
    #@off 'sync', @_mark_as_synced

  _load_before: (callback, xhr, data)->
    @is_synced = false
    console.log "Loading #{@class_name}..."
    #@_started_loading = true
    callback(xhr, data) if callback

  _load_success: (callback, model, response, options) ->
    console.log "#{@class_name} has been loaded."
    #@_started_loading = false
    #@trigger 'sync', model, response, options
    if callback
      @once 'sync', -> callback(model, response, options)

  _load_error: (callback, model, xhr, options) ->

    console.log "#{@class_name} hasn't been loaded."
    #@_started_loading = false
    callback(model, xhr, options) if callback

  _save_before: (callback, xhr, data)->
    @is_synced = false
    console.log "Saving #{@class_name}..."
    callback(xhr, data) if callback

  _save_success: (callback, model, response, options) ->
    console.log "#{@class_name} has been saved."
    #@trigger 'sync', model, response, options
    if callback
      @once 'sync', -> callback(model, response, options)

  _save_error: (callback, model, xhr, options) ->
    console.log "#{@class_name} hasn't been saved."
    callback(model, xhr, options) if callback

  _define_callbacks: (type, options) ->
    options.beforeSend = _.bind(@["_#{type}_before"],  this, options.beforeSend) if options.beforeSend
    options.success    = _.bind(@["_#{type}_success"], this, options.success)    if options.success
    options.error      = _.bind(@["_#{type}_error"],   this, options.error)      if options.error
    return options

  _wrap_param_root: (data) ->
    wrap = {}
    if @paramRoot
      wrap[@paramRoot] = data
      data = wrap
    data