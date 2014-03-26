class InputHealth.ErrorStorage
  errors: null
  constructor: ->
    @errors = {}

  add: (xhr) -> @set _.uniqueId('error_xhr_'), xhr
  set: (id, data) ->
    @errors[id] = data
    id
  get: (id) -> @errors[id]
  remove: (id)-> delete @errors[id]


_.each ['each', 'map'], (method) ->
  InputHealth.ErrorStorage.prototype[method] = ->
    args = _(arguments).slice()
    args.unshift(@errors)
    _[method].apply(_, args)