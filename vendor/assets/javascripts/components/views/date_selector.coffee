class InputHealth.DateSelector extends InputHealth.DateTimeSelector
  className: 'ih-datetime-selector'
  template: JST['components/templates/date_selector']
  initialize: (options = {})->
    @today        = _.time()
    @current_year = @today.year()
    options.in = [@current_year-100, @current_year] unless options.in

    @years  = _.range(options.in[0], options.in[1]+1)
    @months = switch options.month_format or 'normal'
                when 'normal' then moment.months()
                when 'short'  then moment.monthsShort()
                when 'number' then _.range(1,13)

    @field      = options.field

    @_render()
    @_position()


  _render: ->
    data = @field.val() or @today.format('YYYY-MM-DD')
    data = data.split('-')
    data = year: parseInt(data[0],10), month: parseInt(data[1],10), date: parseInt(data[2],10)
    @$el.html @template data
    @select_boxes  = @$(".ih-datetime-select")
    @date_select   = @select_boxes.eq(0).val(data.date)
    @month_select  = @select_boxes.eq(1).val(data.month)
    @year_select   = @select_boxes.eq(2).val(data.year)

    @_update_value @year_select
    @_update_value @month_select
    @_update_value @date_select


  _update_value: ->
    @field.val [@year_select.val(), ("0" + @month_select.val()).substr(-2, 2), ("0" + @date_select.val()).substr(-2, 2)].join '-'
    @field.change()


