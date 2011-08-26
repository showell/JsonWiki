Atom = (s) ->
  elem = $("<textarea>")
  elem.val(s)
  self =
    element: -> elem
    value: -> elem.val()
    
ListRawView = (array) ->
  div = $("<div>")
  textarea = $("<textarea>").attr("rows", 10)
  textarea.html JSON.stringify(array, null, " ")
  div.append textarea
  self =
    element: -> div
    value: -> JSON.parse textarea.html()
    
ListEditView = (subwidgets) ->
  ul = $("<ul>")
  for w in subwidgets
    li = $("<li>").html w.element()
    ul.append li
  self =
    element: -> ul
    value: -> _.map subwidgets, (w) -> w.value()

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
  self =
    current: -> widgets[index]
    toggle: ->
      self.current().element().hide()
      val = self.current().value()
      index = (index + 1) % widgets.length
      self.current().element().show()
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
  subwidgets = _.map(array, widgetizer)
  self =
    element: -> elem
    value: -> multi_view.current().value()
    append: (subelem) -> elem.append subelem
    
  multi_view = MultiView self, [
    ListRawView(array),
    ListEditView(subwidgets),
  ]

  create_save_link(self, save_method)  
  self
    
jQuery(document).ready ->
  save = (data) -> console.log data
  root = List(["hello", "world"], Atom, save)
  $("#content").append root.element()
  console.log root.value()