_.mixin
  round: (float, length = 0) ->
    x = Math.pow(10,length)
    Math.round(float*x)/x