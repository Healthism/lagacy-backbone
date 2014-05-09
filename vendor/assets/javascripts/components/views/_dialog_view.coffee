class InputHealth.DialogView extends InputHealth.View
  _dialog_template: JST['components/templates/dialog']
  _default_options:
    valign: 'normal'
    easy_to_close: true

  _default_events:
    'click .close-dialog': 'click_to_close'

  visible: false
  dialog_options: {}
  events: {}

  constructor: (options = {}) ->
    window._ih_dialogs ||= []

    @callback = options.callback || {}
    delete options.callback

    @events         = _(@events).defaults @_default_events
    @dialog_options = _(@dialog_options).defaults @_default_options
    @dialog_options = _(options).defaults @dialog_options

    @_render_dialog()
    super options
    @_position_dialog()
    @show()
    _ih_dialogs.push this


  click_to_close: (e)->
    e.preventDefault()
    @close()

  show: ->
    @dialog_el.show()
    @visible = true
    @_lock_body_scroll()

  hide: ->
    @dialog_el.hide()
    @visible = false
    @_unlock_body_scroll() if _(_ih_dialogs).every (view) -> not view.visible

  close: ->
    @callback.close.call this if @callback.close instanceof Function
    @remove()
    @dialog_el.remove()
    _ih_dialogs.splice _ih_dialogs.indexOf(this), 1
    @_unlock_body_scroll() if _ih_dialogs.length is 0


  _render_dialog: ->
    @dialog_options.dialog_id ||= [ 'ih-dialog', (new Date).getTime() ].join('-')

    @dialog_el = @_render_dialog_element().hide()
    @dialog_el.attr id: @dialog_options.dialog_id
    @dialog_el.addClass @dialog_options.dialog_class if @dialog_options.dialog_class
    @dialog_el.addClass @dialog_options.style
    @dialog_el.css 'z-index', _ih_dialogs.length + 2000

    @dialog_content_area = @dialog_el.find ".ih-dialog-content-area"
    @dialog_content_area.addClass "valign-#{@dialog_options.valign}" if @dialog_options.valign

    if @dialog_options.easy_to_close
      @dialog_content_area.on 'click', (e) =>
        @click_to_close e if e.target is @dialog_content_area[0]


  _render_dialog_element: ->
    $ @_dialog_template()


  _position_dialog: ->
    @callback.open.call this if @callback.open instanceof Function
    @_position_view_element()
    $('body').append @dialog_el

  _position_view_element: ->
    @dialog_content_area.append @el

  _lock_body_scroll: ->
    $("body").addClass('ih-fixed').attr 'scroll', no

  _unlock_body_scroll: ->
    $("body").removeClass("ih-fixed").removeAttr "scroll"