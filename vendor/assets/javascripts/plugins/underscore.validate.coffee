_.us_phone_format = /^1?([2-9]..)([2-9]..)(....)$/
_.email_format    = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

_.mixin
  format: (string, type) ->
    switch type
      when 'us_phone'
        string = string.match(/[0-9]/g).join('').replace(@us_phone_format,'$1$2$3')
        format = '1 ($1) $2-$3'
        string.replace(@us_phone_format, format)

  validate: (string, type) ->
    try
      switch type
        when 'us_phone'
          return false if string.match(/[^0-9-\(\)+ ]/g)
          return Boolean string.match(/[0-9]/g).join('').match @us_phone_format
        when 'email'
          return string.match @email_format
    catch e
      return false