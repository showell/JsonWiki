Atom = (s) ->
  s = "" unless s?
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
      if !hash?
        hash = self.default()
      hash_to_table(table, hash, widgetizer)
      div.append table
    value: ->
      table_to_hash(table)
    default: ->
      hash = {}
      for key, value of widgetizer
        hash[key] = value.default
      hash
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
    widget = widgetizer[key].widgetizer(value)
    td_value.html(widget.element())
    tr = $("<tr>")
    set_callbacks(tr, widget)
    table.append tr
    tr.append td_key
    tr.append td_value
  table

add_insert_link = (widget, ul, index) ->
  li = $("<li>")
  a = $("<a href='#'>").html "insert"
  li.append a
  ul.append li
  a.click ->
    new_element = widget.new_element(index)
    console.log "elem", new_element.element()
    console.log "HTML", new_element.element().html()
    li.append new_element.element()

ListEditView = (array, widgetizer) ->
  ul = $("<ul>")
  subwidgets = []
  self =
    element: -> ul
    value: -> _.map subwidgets, (w) -> w.value()
    set: (array) ->
      ul.empty()
      subwidgets = _.map(array, widgetizer)
      insert_links = []
      insert_links.push add_insert_link(self, ul, 0)
      for w, index in subwidgets
        li = $("<li>").html w.element()
        ul.append li
        insert_links.push add_insert_link(self, ul, index+1)
    new_element: (index) -> 
      widget = widgetizer()
      subwidgets.splice(index, 0, widget)
      widget
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
      friends: ["bob", "cal"]
    },
    {
      name: "bob"
      salary: "500"
      friends: ["alice", "cal"]
    }
  ]
  schema = (data) ->
    List data,
      (sublist) -> Hash sublist,
        name:
          widgetizer: Atom
          default: ''
        salary:
          widgetizer: Atom
          default: [0]
        friends:
          widgetizer: (array) -> List array, Atom
          default: []
      save
  root = schema(data)
  $("#content").append root.element()
  
  