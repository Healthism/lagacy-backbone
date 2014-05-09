class InputHealth.AlertDialog extends InputHealth.DialogView
  template: JST['components/templates/alert_dialog']
  className: 'ih-dialog-content alert-dialog'

  dialog_options:
    valign: 'middle'
    easy_to_close: false

  default_alert_options:
    title: 'Alert'
    message: ''
    style: 'normal'
    button:
      classes: 'okay', text: 'Okay'

  events:
    'tap .close.btn': 'close'

  initialize: (options)->
    options = _(options).defaults @default_alert_options

    @$el.html @template options
    @$(".close.btn").focus()


InputHealth.Alert = InputHealth.AlertDialog