_.mixin
  sum: (obj, iterator, context) ->
    output = 0
    return output if obj is null
    _.each obj, (value, index, list) -> output+=value
    return output;