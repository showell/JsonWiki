Atom = (s) ->
  elem = $("<textarea>")
  elem.val(s)
  self =
    element: -> elem
    value: -> elem.val()
    
ListEditView = (subwidgets) ->
  ul = $("<ul>")
  for w in subwidgets
    li = $("<li>").html w.element()
    ul.append li
  self =
    element: -> ul
    value: -> _.map subwidgets, (w) -> w.value()

MultiView = (widgets) ->
  self =
    current: -> widgets[0]

create_save_link = (widget, save_method) ->
  save_link = $("<a href='#'>").html("save")
  save_link.click ->
    save_method widget.value()
  elem = widget.element()
  elem.append save_link
  
List = (array, widgetizer, save_method) ->
  subwidgets = _.map(array, widgetizer)
  list_edit_view = ListEditView(subwidgets)
  multi_view = MultiView([list_edit_view])
  elem = $("<div>")
  elem.append multi_view.current().element()
  
  self =
    element: -> elem
    value: -> multi_view.current().value()
    
  create_save_link(self, save_method)  
  self
    
jQuery(document).ready ->
  save = (data) -> console.log data
  root = List(["hello", "world"], Atom, save)
  $("#content").append root.element()
  console.log root.value()