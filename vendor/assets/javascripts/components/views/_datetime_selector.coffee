class InputHealth.DateTimeSelector extends Backbone.View
  className: 'ih-datetime-selector'

  events:
    'change select': 'update_value'

  update_value: (e) ->
    e.stopPropagation()
    @_update_label $(e.currentTarget)
    @_update_value()

  _update_label: ($select) ->
    $select.closest('.ih-datetime-field').find('.ih-datetime-value').html $select.find("option:selected").text()

  _update_value: ->

  _position: ->
    @field.after @el
    @$el.append @field.prop 'type', 'hidden'