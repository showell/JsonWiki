Atom = (s) ->
  elem = $("<textarea>")
  self =
    element: -> elem
    value: -> elem.val()
    set: (s) -> elem.val(s)
  self.set(s)
  self
    
ListRawView = (array) ->
  div = $("<div>")
  textarea = $("<textarea>").attr("rows", 10)
  textarea.css
  div.append textarea
  self =
    element: -> div
    value: ->
      JSON.parse textarea.val()
    set: (array) ->
      textarea.val JSON.stringify(array, null, " ")
  self.set(array)
  self
  
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
  self.set()
  self

create_toggle_link = (parent, toggle) ->
  toggle_link = $("<a href='#'>").html "toggle"
  toggle_link.click toggle
  parent.append ' '
  parent.append toggle_link

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
  console.log widgets
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
  
List = (array, widgetizer, save_method) ->
  elem = $("<div>")
  self =
    element: -> elem
    value: -> multi_view.value()
    append: (subelem) -> elem.append subelem
    
  multi_view = MultiView self, [
    ListRawView(array),
    ListEditView(array, widgetizer),
  ]

  create_save_link(self, save_method)  
  self
    
jQuery(document).ready ->
  save = (data) -> console.log data
  root = List(["hello", "world"], Atom, save)
  $("#content").append root.element()
  console.log root.value()