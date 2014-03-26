_.mixin
  mapFilter: (obj, iterator, context) ->
    results = []
    return results if obj is null
    _.each obj, (value, index, list) ->
      results[results.length] = data if (data = iterator.call(context, value, index, list))
    return results;