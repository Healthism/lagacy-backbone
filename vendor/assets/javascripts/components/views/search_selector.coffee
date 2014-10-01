class InputHealth.SearchSelectView extends InputHealth.View
  className: 'ih-search-selector'
  default_options:
    delay: 0
    ajax: false
    type_to_search: true
    template:      JST['components/templates/search_select']
    item_template: JST['components/templates/search_select/item']


  focused_index: -1

  initialize: (options)->
    @options       = _(options).defaults(@default_options)
    @wrap          = @options.wrap
    @template      = @options.template
    @item_template = @options.item_template
    @collection    = @options.collection

    @search_method = if @options.ajax then '_run_ajax_search_method' else '_search_existing_item'

    @_render()
    @_render_items() unless @options.ajax
    @_position()

    @events = _(_(@events).clone()).defaults @default_events
    @events['keyup.default .search-field'] = 'search_items' if @options.type_to_search
    _(@events).extend options.events if options.events



  default_events:
    'keydown.default': 'move_focus'
    'submit.default form': 'search_items_by_submit'
    'selected-item.default': 'run_select_callback'

  events: {}


  move_focus: (e)->
    if @_found_views and @_found_views.length
      switch e.keyCode
        when $key.up    then @_move_focus_up()
        when $key.down  then @_move_focus_down()
        when $key.enter then @_select_focused_item()



  search_items_by_submit: (e)->
    e.preventDefault()
    clearTimeout @_delayed
    @[@search_method]()

  search_items: (e)->
    clearTimeout @_delayed
    search_items = _(@[@search_method]).bind this
    @_delayed = setTimeout search_items, @options.delay


  _move_focus_up: ->
    @focused_index--
    @focused_index = 0 if @focused_index < 0
    @_found_views[@focused_index].focus()

  _move_focus_down: ->
    max_index = @_found_views.length-1
    @focused_index++
    @focused_index = max_index if @focused_index > max_index
    @_found_views[@focused_index].focus()

  _select_focused_item: ->
    @focused_item_view.select() if @focused_index > -1

  _search_existing_item: ->
    @_hide_placeholder()
    @_found_views = []
    search_data = _(@form.serializeObject())

    if search_data.any((val) -> Boolean val)
      _(@_views).each (view) -> view.hide()
      count = 0
      @collection.each (model) =>
        condition = (val, key) ->
          keyword = new RegExp(val, 'i')
          keyword.test model.get key

        if search_data.every condition
          found_view = @_views_indexed_by_id[model.id]
          found_view.show()
          found_view.update_index count
          @_found_views.push found_view
          count++

      @_show_placeholder() unless count

    else
      _(@_views).each (view, index) =>
        view.show()
        view.update_index index
        @_found_views.push view


  _run_ajax_search_method: ->
    @options.search.call this, this if @options.search instanceof Function

  run_select_callback: (e, model)->
    @options.select.call this, this, model if @options.select instanceof Function

  _render: ->
    @$el.html @template @options
    @searched_items = @$(".searched-items")
    @form           = @$(".search-form")
    @placeholder    = @$(".placeholder")
    @_hide_placeholder()



  render_items: (collection)->
    @collection = collection
    @searched_items.empty()
    @_hide_placeholder()
    @_render_items()

  remove_item_by: (model) ->
    item_view = @_views_indexed_by_id[model.id]
    item_view.remove()


  _render_items: ->
    @focused_index = -1
    @_found_views = []
    @_views = []
    @_views_indexed_by_id = {}

    if @collection and @collection.length
      @collection.each (model, index) =>
        view = @new InputHealth.SearchSelect.ItemView,
          app: @app, parent: this, model: model
          template: @item_template, index: index

        @_found_views.push view
        @_views.push view
        @_views_indexed_by_id[model.id] = view

    else
      @_show_placeholder()

  _hide_placeholder: -> @placeholder.hide()
  _show_placeholder: -> @placeholder.show()

  _position: ->
    @wrap.append @el if @wrap