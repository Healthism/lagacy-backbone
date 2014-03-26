class InputHealth.FetchHelper
  load: ->
    preset_name = arguments[0]
    if @presets[preset_name] instanceof Function
      args = _.toArray(arguments)
      args.shift()
      @presets[preset_name].apply this, args
    else
      console.error "No fetch preset of #{preset_name}"