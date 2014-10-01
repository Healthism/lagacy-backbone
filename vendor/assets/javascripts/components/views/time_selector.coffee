class InputHealth.TimeSelector extends InputHealth.DateTimeSelector
  template: JST['components/templates/time_selector']
  initialize: (options) ->
    @start_time = options.start_time
    @field      = options.field

    @_render()
    @_position()


  _render: ->
    data = InputHealth.TimeStringHelper.split @field.val()
    @$el.html @template data
    @select_boxes  = @$(".ih-datetime-select")
    @hour_select   = @select_boxes.eq(0).val(data.hour)
    @minute_select = @select_boxes.eq(1).val(data.min)
    @ampm_select   = @select_boxes.eq(2).val(data.am_pm)

    @_update_label @hour_select
    @_update_label @minute_select
    @_update_label @ampm_select


  _update_value: ->
    @field.val InputHealth.TimeStringHelper.to_24 @hour_select.val(), @minute_select.val(), @ampm_select.val(), start_time: @start_time
    @field.change()