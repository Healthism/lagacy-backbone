_.mixin
  time: ->
    if arguments.length is 1 and typeof arguments[0] is 'string'
      arguments[0] = arguments[0].replace @_timezone_regex, ''

    obj = moment.apply moment, arguments
    if not obj._tz_applied and offset = @_tz

      #offset -= 60 if obj.isDST()

      offset = obj.zone() - offset
      obj.subtract 'hour', offset/60 if obj._i and not obj._tzm
      obj.zone @_tz
      obj._tz_applied = true
      obj.toString = @_to_string_without_timezone
    obj


  setTimeZone: (string) ->
    @_tz = moment().zone(string)._offset
    @_timezone_regex = /[\-\+]\d{2}:\d{2}/

  _to_string_without_timezone: ->
    @clone().format('YYYY-MM-DD HH:mm:ss')