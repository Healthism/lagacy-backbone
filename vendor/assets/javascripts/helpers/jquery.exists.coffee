jQuery.fn.exists = (parent = document) ->
  $(parent).find(this).length > 0