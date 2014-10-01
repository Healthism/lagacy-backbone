class InputHealth.Calendar.DayView extends InputHealth.View
  tagName:   'li'
  className: 'day-item'
  past_day:  false

  initialize: (options) ->
    @index      = options.index
    @day        = options.day
    @month      = @day.month()+1
    @weekday    = options.weekday
    @week_view  = options.week_view

    @day.view = this

    @_render()
    @_position()

  events:
    'click': 'select'

  select: ->
    @parent._selected_day_view.mark_as_unselected() if @parent._selected_day_view
    @mark_as_selected()

  mark_as_selected: ->
    day = @day.clone()
    @$el.trigger 'selected-day', day
    @$el.addClass 'active'
    @parent.selected_day = day
    @parent._selected_day_view = this

  mark_as_unselected: ->
    @$el.removeClass 'active'

  mark_as_today: ->
    @$el.addClass 'today'

  mark_as_past_day: ->
    @past_day = true
    @$el.addClass 'past-day'

  mark_as_other_month: ->
    @$el.addClass 'other-month'

  _render: ->

    @$el.html "<div class='label'>#{@day.date()}</div>"
    @$el.addClass "weekday-#{@weekday}"
    @mark_as_other_month() if @month isnt @parent.current_month

  _position: ->
    @week_view.day_list.append @el