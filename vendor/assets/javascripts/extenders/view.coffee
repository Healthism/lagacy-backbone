class InputHealth.View extends Backbone.View
  constructor: (options = {})->
    @_child_views = []
    @app    = options.app
    @parent = options.parent
    super options


  render_child_view: (view, options) ->
    new_view = new view options
    @_child_views.push new_view
    new_view

  new: ->
    @render_child_view.apply this, arguments


  remove: ->
    _(@_child_views).each (view) -> view.remove()
    super