MultiView = (parent, widgets) ->
  div = $("<div>")
  parent.append div
  parent = div
  index = 0
  curr = widgets[0]
  self =
    value: -> curr.value()
    toggle: ->
      try
        val = curr.value()
      catch e
        alert e
        return
      curr.element().hide()
      index = (index + 1) % widgets.length
      curr = widgets[index]
      curr.set(val)
      curr.element().show()
  for widget in widgets
    widget.element().hide()
    parent.append widget.element()
  widgets[0].element().show()
  create_toggle_link(parent, self.toggle)
  self


create_toggle_link = (parent, toggle) ->
  toggle_link = $("<a href='#'>").html "toggle"
  toggle_link.click toggle
  parent.prepend toggle_link
  parent.prepend " "

create_save_link = (widget, save_method) ->
  save_link = $("<a href='#'>").html("save")
  save_link.click ->
    save_method widget.value()
  elem = widget.element()
  elem.append ' '
  elem.append save_link

TextareaWidget = (s) ->
  s = "" unless s?
  div = $("<div>")
  div.append "<br />"
  elem = $("<textarea>")
  div.append elem
  self =
    element: -> div
    value: -> elem.val()
    set: (s) -> elem.val(s)
  self.set(s)
  self
  
HtmlView = (s) ->
  elem = $("<pre>")
  self =
    element: -> elem
    value: -> s
    set: (val) ->
      s = val
      elem.html(s)
  self.set(s)
  self

StringWidget = (s, save_method) ->
  elem = $("<div>")
  self =
    element: -> elem
    value: -> multi_view.value()
    append: (subelem) -> elem.append subelem
    
  multi_view = MultiView self, [
    TextareaWidget(s),
    HtmlView(s)
  ]

  create_save_link(self, save_method) if save_method
  self 
 
BooleanWidget = (bool) ->
  bool = !!bool
  elem = $("<input type='checkbox'>")
  self =
    element: -> elem
    value: -> !!elem.prop("checked")
    set: (bool) -> elem.prop("checked", bool)
  self.set(bool)
  self

autosize_textarea = (textarea, json) ->
  rows = json.split("\n")
  textarea.attr("rows", rows.length + 2)  
  max_col = 0
  for row in rows
    max_col = row.length if row.length > max_col
  textarea.attr("cols", max_col)
    
JsonRawView = (array) ->
  div = $("<div>")
  textarea = $("<textarea>").attr("rows", 10)
  textarea.css("font-size", "15px")
  div.append textarea
  self =
    element: -> div
    value: ->
      JSON.parse textarea.val()
    set: (array) ->
      json = JSON.stringify(array, null, " ")
      textarea.val json
      try
        autosize_textarea textarea, json
      catch e
        # need to clean up defaults
  self.set(array)
  self


Hash = (hash, widgetizer, save_method) ->
  elem = $("<div>")
  self =
    element: -> elem
    value: -> multi_view.value()
    append: (subelem) -> elem.append subelem

  multi_view = MultiView self, [
    HashEditView(hash, widgetizer),
    JsonRawView(hash),
  ]

  create_save_link(self, save_method) if save_method
  self
  
HashEditView = (hash, widgetizer) ->
  table= $("<table>")
  div = $("<div>")
  trs = []
  self = 
    element: -> div
    set: (hash) ->
      trs = hash_to_table(table, hash, widgetizer)
      div.append table
    value: ->
      table_to_hash(trs)
  self.set(hash)
  self
    
table_to_hash = (trs) ->
  hash = {}
  for tr in trs
    key = (tr.data "get_key")()
    value = (tr.data "get_value")()
    hash[key] = value
  hash

set_callbacks = (tr, widget) ->
  tr.data "get_key", ->
    tr.find(".key").html()
  tr.data "get_value", ->
    widget.value() 

hash_to_table = (table, hash, widgetizer) ->
  table.empty()
  trs = []
  for key, value of hash
    td_key = $("<th class='key'>").css("text-align", "left")
    td_value = $("<td class='value'>")
    td_key.html(key)
    widget = widgetizer[key](value)
    td_value.html(widget.element())
    tr = $("<tr valign='top'>")
    trs.push tr
    set_callbacks(tr, widget)
    table.append tr
    tr.append td_key
    tr.append td_value
  trs

add_insert_link = (widget, index) ->
  li = $("<li>")
  a = $("<a href='#'>").html "insert"
  li.append a
  a.click ->
    new_element = widget.new_element(index)
    widget.update_links(new_element, index)
  self =
    set: (idx) -> index = index
    element: li

ListEditView = (array, widgetizer, default_value) ->
  ul = $("<ul>")
  subwidgets = []
  insert_links = []
  self =
    element: -> ul
    value: -> _.map subwidgets, (w) -> w.value()
    set: (array) ->
      ul.empty()
      subwidgets = _.map(array, widgetizer)
      link = add_insert_link(self, 0)
      insert_links.push link
      ul.append link.element
      for w, index in subwidgets
        ul.append self.wrap w
        link = add_insert_link(self, index+1)
        insert_links.push link
        ul.append link.element
    wrap: (w) ->
      li = $("<li>").html w.element()
      li.attr("class", "ListWidgetItem")
      li
    update_links: (element, index) ->
      li = $(ul.children()[index*2])
      new_li = self.wrap(element)
      li.after(new_li)
      link = add_insert_link(self, index+1)
      insert_links.push link
      new_li.after link.element
      for insert_link, i in insert_links
        insert_link.set(i)
    new_element: (index) ->
      console.log "new_element", default_value 
      widget = widgetizer(default_value)
      subwidgets.splice(index, 0, widget)
      widget
  self.set(array)
  self

List = (array, options) ->
  {widgetizer, default_value, save_method} = options
  elem = $("<div>")
  self =
    element: -> elem
    value: -> multi_view.value()
    append: (subelem) -> elem.append subelem
    
  multi_view = MultiView self, [
    ListEditView(array, widgetizer, default_value),
    JsonRawView(array),
  ]

  create_save_link(self, save_method) if save_method
  self
    
$.JsonWiki =
  Hash: Hash
  List: List
  StringWidget: StringWidget
  BooleanWidget: BooleanWidget
  
  