class InputHealth.Calendar.WeekView extends InputHealth.View
  tagName: 'li'
  className: 'week-item'

  initialize: (options) ->
    @week = options.week
    @_render()
    @_position()

  mark_as_week_of_today: ->
    @$el.addClass 'week-of-today'

  _render: ->
    @day_list = $('<ul class="day-list small-block-grid-7 medium-block-grid-7">')
    @$el.html @day_list

    @$el.addClass "week-#{@week}"

  _position: ->
    @parent.week_list.append @el