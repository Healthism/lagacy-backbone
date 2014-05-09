class InputHealth.ConfirmDialog extends InputHealth.DialogView
  template: JST['components/templates/confirm_dialog']
  className: 'ih-dialog-content confirm-dialog'

  dialog_options:
    valign: 'middle'
    easy_to_close: false


  default_confirm_options:
    title: 'Confirm'
    message: 'Are you sure you want to continue?'
    buttons: [
      {text: 'Cancel', classes: 'cancel' },
      {text: 'Okay', classes: 'accept primary', focused: true }
    ]


  events:
    'tap .accept.btn': 'accept'
    'tap .cancel.btn': 'cancel'


  initialize: (options)->
    options = _(options).defaults @default_confirm_options
    @accept_callback = options.accept
    @cancel_callback = options.cancel

    @$el.html @template options
    focused_btn = _(options.buttons).find (button) => button.focused
    @$(".#{focused_btn.classes.replace(' ', '.')}.btn").focus()

  accept: ->
    if @accept_callback instanceof Function
      @accept_callback.call this, this
    else
      @close()

  cancel: ->
    if @cancel_callback instanceof Function
      @cancel_callback.call this, this
    else
      @close()


InputHealth.Confirm = InputHealth.ConfirmDialog