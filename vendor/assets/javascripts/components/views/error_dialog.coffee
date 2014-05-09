class InputHealth.ErrorDialog extends InputHealth.DialogView
  className: 'ih-dialog-content alert-dialog error-dialog'
  template: (options)->
    @_template = JST["components/templates/error_dialogs/#{options.error.type}"]
    @_template options


  dialog_options:
    valign: 'middle'
    easy_to_close: false
    style: 'negative'

  default_error_options:
    title: 'Something went wrong'
    error:
      type: 'server'

  initialize: (options)->
    options = _(options).defaults @default_error_options

    @error_handler = options.error_handler || window._error_handler
    @$el.addClass options.error.type
    @$el.html @template options


  events:
    'tap .retry.btn': 'retry'
    'tap .close.btn': 'close'

  retry: (e)->
    @error_handler.retry @last_error_id,
      beforeSend: => @close()


InputHealth.Alert = InputHealth.AlertDialog