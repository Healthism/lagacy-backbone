class InputHealth.TooltipDialog extends InputHealth.DialogView
  @dialogs = []

  className: 'ih-tooltip-dialog-content'
  _dialog_template: JST['components/templates/tooltip_dialog']
  _default_options:
    width: 300
    position: 'bottom-right'
    easy_to_close: true
    screen_margin: 30
    focus_to_first_input: true



  show: ->
    @dialog_el.addClass('preparing').show()
    @_lock_body_scroll()
    @_bind_keyboard_events()
    @refresh_position()
    @dialog_el.removeClass('preparing')

    @visible = true
    @$("input").first().focus() if @dialog_options.focus_to_first_input


  close: ->
    InputHealth.TooltipDialog.dialogs = _(InputHealth.TooltipDialog.dialogs).without this
    @_unbind_keyboard_events()
    @dialog_options.on_close() if @dialog_options.on_close
    super



  _render_dialog: ->
    super

    @tooltip_body    = @dialog_el.find(".ih-tooltip-body")
    @tooltip_content = @dialog_el.find(".ih-tooltip-content")
    @tooltip_tails   = @dialog_el.find(".ih-tooltip-tail")

    if @dialog_options.easy_to_close
      @dialog_el.on 'click', (e) =>
        @click_to_close e if e.target is @dialog_el[0]

      @dialog_el.on 'click', '.ih-tooltip-tail', (e) =>
        @click_to_close e



  _position_view_element: ->
    @tooltip_content.append @el


  _bind_keyboard_events: ->
    unless InputHealth.TooltipDialog.dialogs.length
      $(window).bind 'keyup.tooltip', (e) =>
        switch e.keyCode
          when $key.esc then _(InputHealth.TooltipDialog.dialogs).last().close()

    InputHealth.TooltipDialog.dialogs.push this


  _unbind_keyboard_events: ->
    unless InputHealth.TooltipDialog.dialogs.length
      $(window).unbind 'keyup.tooltip'


  update_target: (el)->
    @dialog_options.to = el


  refresh_position: ->

    @tooltip_body.removeClass @_previous_body_angle if @_previous_body_angle
    @tooltip_tails.removeClass @_previous_tail_angle if @_previous_tail_angle

    body_angle     = @dialog_options.position
    body_width     = @dialog_options.width
    body_height    = @tooltip_body.height()
    screen_width   = $(window).width()
    screen_height  = $(window).height()
    maximum_height = screen_height - 20 - @dialog_options.screen_margin * 2
    body_offset    = {bottom: '', top: '', left: '', right: ''}
    tail_offset    = {bottom: '', top: '', left: '', right: ''}
    $target_el     = $ @dialog_options.to

    target_offset = $target_el.offset()
    target_size   = width: $target_el.outerWidth(), height: $target_el.height()

    target_offset.top -= $('body').scrollTop()


    switch @dialog_options.position
      when 'bottom-right'
        tail_angle       = 'vertical'

        maximum_height_of_top    = target_offset.top - @dialog_options.screen_margin
        maximum_height_of_bottom = maximum_height - target_offset.top + @dialog_options.screen_margin - target_size.height

        if maximum_height_of_bottom < 300
          body_angle = 'top-right'
          body_offset.bottom = screen_height - target_offset.top

        else
          body_offset.top  = target_offset.top + target_size.height

        body_offset.left = target_offset.left + target_size.width - body_width
        tail_offset.right = target_size.width/2


      when 'right-top'
        adjust_height    = 20
        tail_angle       = 'horizontal'
        body_offset.left = target_offset.left + target_size.width
        body_offset.top  = target_offset.top - adjust_height

        # prevent horizontal position over screen

        overwidth = body_offset.left + body_width - screen_width
        overwidth += @dialog_options.screen_margin

        if overwidth > 0
          body_offset.left = target_offset.left - body_width
          body_angle = 'left-top'

        # prevent vertial position over screen

        tail_offset.top = 10 + adjust_height
        tail_offset.top = target_size.height / 2 + adjust_height if target_offset.height > 30


        if body_height > maximum_height
          @tooltip_body.css 'max-height', maximum_height
          body_height = maximum_height

        overheight = body_offset.top + body_height - screen_height
        overheight += @dialog_options.screen_margin

        if overheight > 0
          body_offset.top -= overheight
          tail_offset.top += overheight



    body_offset.width = @dialog_options.width

    @tooltip_body.css body_offset
    @tooltip_body.addClass body_angle
    @tooltip_tails.css tail_offset
    @tooltip_tails.addClass tail_angle

    @_previous_body_angle = body_angle
    @_previous_tail_angle = tail_angle