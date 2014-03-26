class window.Watcher
  constructor: (options) ->
    @while = options.while
    @after_finished = options.after_finished
    @repeat = =>
      if @while(this) and @_playing
        options.repeat this
      else
        @finish()

    @_playing  = true
    @_interval = setInterval @repeat, options.delay

    return this

  stop: ->
    clearInterval @_interval
    @_playing = false
    @finish()

  finish: ->
    clearInterval @_interval
    @after_finished this if @after_finished instanceof Function