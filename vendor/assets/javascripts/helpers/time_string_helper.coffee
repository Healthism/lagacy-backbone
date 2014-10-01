InputHealth.TimeStringHelper =
  split: (string) ->
    output = {am_pm: 'AM'}
    times        = string.split ':'
    output.hour  = parseInt times[0], 10
    output.min   = parseInt times[1], 10
    output.am_pm = 'PM' if output.hour > 11 and output.hour isnt 24
    output.hour  -= 12 if output.hour > 12
    output.hour  = 12 if output.hour is 0
    output

  to_24: (hour, min, am_pm, options = {}) ->
    output = []
    am_pm = am_pm.toLowerCase()
    hour  = parseInt hour
    min   = parseInt min
    if hour isnt 12
      hour += 12 if am_pm is 'pm'
    else
      if am_pm is 'am'
        if options.start_time
          hour -= 12
        else
          hour += 12

    [hour, ("0" + min).substr(-2)].join ':'

  to_12_from_24: (string) ->
    data = @split string
    "#{data.hour}:#{("0"+data.min).substr(-2)} #{data.am_pm}"