class InputHealth.DialogView extends InputHealth.View
  dialog_template: ''
  default_options:
    dialog_class: ''
    content: ''
    title: null
    easy_to_close: true
    auto_show: true

  className: 'ih-dialog'
  initialize: (options = {})->
    


    @show() if @options.auto_show


  show: ->

  hide: ->


  _render: ->
