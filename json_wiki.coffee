Atom = (s) ->
  elem = $("<textarea>")
  self =
    element: -> elem
    value: -> elem.val()
    set: (s) -> elem.val(s)
  self.set(s)
  self
    
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
      textarea.val JSON.stringify(array, null, " ")
  self.set(array)
  self
  
HashEditView = (hash, widgetizer) ->
  table= $("<table>")
  div = $("<div>")
  self = 
    element: -> div
    set: (hash) ->
      hash_to_table(table, hash, widgetizer)
      div.append table
    value: ->
      table_to_hash(table)
  self.set(hash)
  self
    
table_to_hash = (table) ->
  hash = {}
  table.find("tr").each (index, tr) ->
    tr = $(tr)
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
  for key, value of hash
    td_key = $("<td class='key'>")
    td_value = $("<td class='value'>")
    td_key.html(key)
    widget = widgetizer(value)
    td_value.html(widget.element())
    tr = $("<tr>")
    set_callbacks(tr, widget)
    table.append tr
    tr.append td_key
    tr.append td_value
  table
  
ListEditView = (array, widgetizer) ->
  ul = $("<ul>")
  subwidgets = []
  self =
    element: -> ul
    value: -> _.map subwidgets, (w) -> w.value()
    set: (array) ->
      ul.empty()
      subwidgets = _.map(array, widgetizer)
      for w in subwidgets
        li = $("<li>").html w.element()
        ul.append li
  self.set(array)
  self

create_toggle_link = (parent, toggle) ->
  toggle_link = $("<a href='#'>").html "toggle"
  toggle_link.click toggle
  parent.prepend toggle_link
  parent.prepend ' '

MultiView = (parent, widgets) ->
  div = $("<div>")
  parent.append div
  parent = div
  index = 0
  curr = widgets[0]
  self =
    value: -> curr.value()
    toggle: ->
      curr.element().hide()
      val = curr.value()
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

create_save_link = (widget, save_method) ->
  save_link = $("<a href='#'>").html("save")
  save_link.click ->
    save_method widget.value()
  elem = widget.element()
  elem.append ' '
  elem.append save_link

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
  
List = (array, widgetizer, save_method) ->
  elem = $("<div>")
  self =
    element: -> elem
    value: -> multi_view.value()
    append: (subelem) -> elem.append subelem
    
  multi_view = MultiView self, [
    ListEditView(array, widgetizer),
    JsonRawView(array),
  ]

  create_save_link(self, save_method) if save_method
  self
    
jQuery(document).ready ->
  save = (data) -> console.log JSON.stringify data
  data = [
    {
      name: "alice"
      salary: "100"
    },
    {hello: "world"},
  ]
  schema = (data) ->
    List data,
      (sublist) -> Hash(sublist, Atom),
      save
  root = schema(data)
  $("#content").append root.element()
  
  