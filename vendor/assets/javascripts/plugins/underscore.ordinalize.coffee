_.mixin
  ordinalize: (str) ->
    if str
      units = {1: 'st', 2: 'nd', 3: 'rd', 11: 'th', 12: 'th', 13: 'th'}
      num = parseInt(str)
      unit = units[num%100]
      unit = units[num%100%10] || 'th' unless unit
      return num+unit

    else
      return null