autosize_textarea = (textarea, s) ->
  rows = s.split("\n")
  textarea.attr("rows", rows.length + 2)  
  max_col = 0
  for row in rows
    max_col = row.length if row.length > max_col
  textarea.attr("cols", max_col)

StringWidget = (s) ->
  s = "" unless s?
  div = $("<div>")
  div.append "<br />"
  textarea = $("<textarea>")
  div.append textarea
  self =
    element: -> div
    value: -> textarea.val()
    set: (s) ->
      textarea.val(s)
      autosize_textarea(textarea, s)
  self.set(s)
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

Hash = (hash, widgetizer) ->
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


List = (array, options) ->
  {widgetizer, default_value, save_method} = options
  ul = $("<ul>")
  subwidgets = []
  insert_links = []
  self =
    element: -> ul
    value: -> _.map subwidgets, (w) -> w.value()
    set: (array) ->
      ul.empty()
      subwidgets = _.map(array, widgetizer)
      insert_links = []
      link = make_insert_link(self, 0)
      insert_links.push link
      ul.append link.element
      for w, index in subwidgets
        ul.append self.wrap w
        link = make_insert_link(self, index+1)
        insert_links.push link
        ul.append link.element
        
    wrap: (w) ->
      li = $("<li>").html w.element()
      li.attr("class", "ListWidgetItem")
      li
      
    insert_element_at_index: (index) ->
      new_element = self.new_element(index)
      li = $(ul.children()[index*2])
      new_li = self.wrap(new_element)
      li.after(new_li)
      link = make_insert_link(self, index+1)
      insert_links.splice(index+1, 0, link)
      new_li.after link.element
      for insert_link, i in insert_links
        insert_link.set(i)
        
    new_element: (index) ->
      widget = widgetizer(default_value)
      subwidgets.splice(index, 0, widget)
      widget
  self.set(array)
  self


make_insert_link = (widget, index) ->
  li = $("<li>")
  a = $("<a href='#'>")
  li.append a
  a.click ->
    widget.insert_element_at_index(index)
  self =
    set: (idx) ->
      index = index
      a.html "insert element #{index}"
    element: li
  self.set(index)
  self

$.JsonWiki =
  Hash: Hash
  List: List
  StringWidget: StringWidget
  BooleanWidget: BooleanWidget
  
  