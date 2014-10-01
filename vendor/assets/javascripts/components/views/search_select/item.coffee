class InputHealth.SearchSelect.ItemView extends InputHealth.View
  tagName: 'li'
  className: 'selector-item'
  initialize: (options)->
    @template = options.template
    @_render()
    @_position()
    @update_index options.index

  events:
    'click': 'select'
    'mouseenter': 'focus'
    'mouseleave': 'blur'


  select: ->
    @$el.trigger 'selected-item', @model, this

  focus: ->
    @parent.focused_item_view.blur without_update_index: true if @parent.focused_item_view
    @$el.addClass 'focus'
    @$el.focus()
    @parent.focused_index = @index
    @parent.focused_item_view = this

  blur: (options = {})->
    @$el.removeClass 'focus'
    @parent.focused_index = -1 unless options.without_update_index

  show: ->
    @$el.show()

  hide: ->
    @$el.hide()
    @blur()

  update_index: (index)->
    @index = index
    @$el.prop 'tabindex', index+2

  _render: ->
    @$el.html @template @model.as_json()


  _position: ->
    @parent.searched_items.append @el