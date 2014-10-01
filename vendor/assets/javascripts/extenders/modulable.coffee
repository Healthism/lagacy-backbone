class InputHealth.Modulable
  @include: ->
    _(arguments).each (module) =>
      _.extend @prototype, module.prototype
      @prototype.included.call this if @prototype.included instanceof Function

  @before_initialize: ->
    @prototype._before_initialize_methods = [] unless @prototype._before_initialize_methods
    _(arguments).each (method) => @prototype._before_initialize_methods.push method

  @after_initialize: ->
    @prototype._after_initialize_methods = [] unless @prototype._after_initialize_methods
    _(arguments).each (method) => @prototype._after_initialize_methods.push method
