class InputHealth.Collection extends Backbone.Collection
  is_synced: false
  model: InputHealth.Model
  class_name: 'Collection'

  options: {}

  constructor: (collection, options = {}) ->
    if options.callbacks
      options.callbacks =
        beforeSend: _.bind(@_default_before,  this, options.callbacks.beforeSend)
        success:    _.bind(@_default_success, this, options.callbacks.success)
        error:      _.bind(@_default_error,   this, options.callbacks.error)

    @options = _.defaults options, @options
    super collection, options
    @app = @options.app
    @url = @options.url if @options.url
    @class_name = @__proto__?.constructor.name || @class_name
    @on 'sync', @_mark_as_synced, this

  as_json: -> @map (model) -> model.as_json()

  fetch: (options = {}) ->
    if options.silent
      super options
    else
      super _.defaults options, @options.callbacks

  on: (event, callback, context = window, smart = true ) ->
    @off event, callback if smart
    super(event, callback, context)


  _mark_as_synced: ->
    @is_synced = true


  _default_before: (callback, xhr, data)->
    @is_synced = false
    console.log "Loading #{@class_name}..."
    #@_started_loading = true
    callback(xhr, data) if callback

  _default_success: (callback, model, response, options) ->
    console.log "#{@class_name} have been loaded."
    #@_started_loading = false
    callback(model, response, options) if callback
    #@trigger 'sync'

  _default_error: (callback, model, xhr, options) ->
    console.error "#{@class_name} haven't been loaded."
    #@_started_loading = false
    callback(model, xhr, options) if callback
