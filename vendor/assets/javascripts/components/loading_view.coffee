class InputHealth.LoadingView extends InputHealth.View
  id: 'ih-loading-view'
  template: (message = "Loading") ->
    "
    <div class='ih-loading-objects'>
    <span class='ih-loading-circle circle-1'></span>
    <span class='ih-loading-circle circle-2'></span>
    <span class='ih-loading-circle circle-3'></span>
    </div>
    <div class='background'></div>
    <div class='loading-text'>#{message}</div>
    "

  _showed: 0

  initialize: ->
    @_render()
    @_position()


  show: (message)->
    @_showed++
    unless @_showing
      @_showing = true
      @$el.html @template message if message
      @$el.css opacity: 0
      @$el.show()
      @$el.transition opacity: 1, 200
      $('body').addClass('loading')


  hide: ->
    @_showed--
    if @_showed <= 0
      @_showed = 0
      $('body').removeClass('loading')
      @$el.transition opacity: 0, 200, =>
        @_showing = false
        @$el.hide()

  _render: ->
    @$el.html @template()
    @$el.hide()

  _position: ->
    @$el.appendTo "body"
