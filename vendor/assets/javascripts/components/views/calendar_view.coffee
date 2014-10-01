class InputHealth.CalendarView extends InputHealth.View
  template: JST['components/templates/calendar']
  className: 'ih-calendar-view'

  week_view: 'InputHealth.Calendar.WeekView'
  day_view:  'InputHealth.Calendar.DayView'

  initialize: (options) ->
    @wrap         = options.wrap
    @today        = _.time()
    @selected_day = @selected_day or options.selected_day
    @current_day  = (@selected_day or options.current_day or @today).clone()

    @refresh()
    @_position()

  events:
    'tap .previous-month': 'show_previous_month'
    'tap .next-month': 'show_next_month'

  show_previous_month: ->
    @current_day.subtract 'month', 1
    @refresh()
    @$el.trigger 'changed-month', @current_day.clone()

  show_next_month: ->
    @current_day.add 'month', 1
    @refresh()
    @$el.trigger 'changed-month', @current_day.clone()

  refresh: ->
    @_refresh_variable()

    @_render()
    @_render_week_views()
    @_render_day_views()

    if @is_this_month
      @_mark_as_month_of_today()
      @_highlight_today()
      @_highlight_the_week_of_today()
      @_disable_past_days()
    else
      @_unmark_as_month_of_today()

    @_highlight_selected_day() if @selected_day

  get_day_slot_index: (day) ->
    day_view = @day_views[day.format('YYYY-MM-DD')]
    day_view.index


  _refresh_variable: ->
    @current_month  = @current_day.month()+1
    @start_of_month = @current_day.clone().startOf 'month'
    @start_of_month_weekday = @start_of_month.weekday()

    @first_day = @start_of_month.clone()
    @first_day.subtract 'days', @start_of_month_weekday unless @start_of_month_weekday is 0
    @first_day_week = @first_day.week()

    @last_day = @first_day.clone().add 'weeks', 6
    @last_day.subtract 'second', 1

    @is_this_month = @today.year() is @current_day.year() and @today.month() is @current_day.month()
    @today_view = undefined


  _render: ->
    @$el.html @template()
    @week_list = @$(".week-list")


  _render_week_views: ->
    @week_views = {}
    @week_views_by_index = []

    _(_.range(6)).each (index) =>
      week  = @first_day_week+index
      view  = @new eval(@week_view),
                app: @app, parent: this, week: week

      @week_views[week] = view
      @week_views_by_index.push view


  _render_day_views: ->
    @days = []
    @day_views = {}
    @day_views_by_index = []

    _(_.range(42)).each (index) =>
      week_view = @week_views_by_index[Math.floor(index/7)]
      weekday   = (index%7)+1

      day   = @first_day.clone().add 'day', index
      view  = @new eval(@day_view),
                app: @app, parent: this, day: day, week_view: week_view
                weekday: weekday, index: index

      @day_views[day.format('YYYY-MM-DD')] = view
      @day_views_by_index.push view
      @days.push day


  _mark_as_month_of_today: ->
    @$el.addClass 'month-of-today'

  _unmark_as_month_of_today: ->
    @$el.removeClass 'month-of-today'


  _highlight_today: ->
    @today_view = @day_views[@today.format('YYYY-MM-DD')]
    @today_view.mark_as_today() if @today_view


  _highlight_the_week_of_today: ->
    week_of_today_view = @week_views[@today.week()]
    week_of_today_view.mark_as_week_of_today() if week_of_today_view


  _disable_past_days: ->
    _(_.range(0,@day_views_by_index.indexOf(@today_view))).each (index) =>
      view = @day_views_by_index[index]
      view.mark_as_past_day()

  _highlight_selected_day: ->
    @selected_day_view = @day_views[@selected_day.format('YYYY-MM-DD')]
    @selected_day_view.mark_as_selected() if @selected_day_view


  _position: ->
    @wrap.append @el