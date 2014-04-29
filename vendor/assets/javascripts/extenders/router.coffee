class InputHealth.Router extends Backbone.Router
  _.extend this, InputHealth.Modulable

  # module methods
  constructor: (options) ->
    @stored_routes       = []
    @current_child_views = []
    _(@_before_initialize_methods).each (method) => @["_#{method}"].apply this, [this]
    super
    _(@_after_initialize_methods).each (method) => @["_#{method}"].apply this, [this]

  # frame and view render method

  navigate: (fragment, options)->
    if fragment is '@previous'
      @stored_routes.pop()
      fragment = @stored_routes[@stored_routes.length-1]
    else
      @stored_routes.unshift fragment
    super fragment, options

  render_frame: (frame, attributes = {}) ->
    if @frame instanceof frame
      @frame.$el.trigger 'after_initialize', attributes
    else
      @frame = new frame _.defaults(attributes, {app: this, parent: @el})
      @frame.$el.trigger 'after_initialize', attributes

    return @frame


  render_view: (view, attributes = {})->
    unless attributes.cacheable and @_current_view instanceof view
      @_current_view.remove() if @_current_view instanceof Backbone.View
      @_current_view = new view _.defaults(attributes, {app: this})
      @frame.$el.trigger('render-view')
    else
      @_current_view.after_initialize _.defaults(attributes, {app: this}) if @_current_view.after_initialize instanceof Function

    return @_current_view


  # shared method

  combine_loader: (events, context, callback) ->
    i = 0
    _finish_callback = (count) -> callback.call context if events.length == count
    _(events).each (event) =>
      event.call context, =>
        i++
        _finish_callback i

  # private


  _history_start: (pushState = false) ->
    options = if pushState then root: @urlRoot, pushState: true else {}
    Backbone.history.start options
    @stored_routes.push Backbone.history.fragment


InputHealth.Controller = InputHealth.Router