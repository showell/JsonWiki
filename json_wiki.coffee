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
  delete_links = []
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
        ul.append self.wrap w, index
        link = make_insert_link(self, index+1)
        insert_links.push link
        ul.append link.element()
        
    wrap: (w, index) ->
      li = $("<li>")
      delete_link = make_delete_link(self, index)
      delete_links.splice(index, 0, delete_link)
      li.html delete_link.element()
      li.append "<br />"
      li.append w.element()
      li.attr("class", "ListWidgetItem")
      li
      
    insert_element_at_index: (index) ->
      new_element = self.new_element(index)
      widget_li = self.wrap(new_element, index)
      insert_link = make_insert_link(self, index+1)
      insert_links.splice(index+1, 0, insert_link)
      self.insert_list_items_for_index(index, widget_li, insert_link.element()) 
      self.update_insert_delete_links()
     
    insert_list_items_for_index: (index, widget_li, insert_link_li) ->
      position = $(ul.children()[index*2])
      position.after widget_li
      widget_li.after insert_link_li
   
    remove_list_items_for_index: (index) ->
      # this is a bit brittle, but it is due to
      # insert links being list items as well as
      # the actual elements of our list
      position = $(ul.children()[index*2])
      position.remove()
      position = $(ul.children()[index*2])
      position.remove()
      
    delete_element_at_index: (index) ->
      widget = subwidgets[index]
      self.remove_list_items_for_index(index)
      subwidgets.splice(index, 1)
      insert_links.splice(index, 1)
      delete_links.splice(index, 1)
      self.update_insert_delete_links()
      
    update_insert_delete_links: ->
      for insert_link, i in insert_links
        insert_link.set(i)
      for delete_link, i in delete_links
        delete_link.set(i)
          
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
      index = idx
      a.html "insert element #{index}"
    element: -> li
  self.set(index)
  self

make_delete_link = (widget, index) ->
  link = $("<a href='#'>")
  link.click ->
    widget.delete_element_at_index(index)
  self =
    set: (idx) ->
      index = idx
      link.html "delete element #{index}"
    element: -> link
  self.set(index)
  console.log link
  self

$.JsonWiki =
  Hash: Hash
  List: List
  StringWidget: StringWidget
  BooleanWidget: BooleanWidget
  
  