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

List = (array, widgetizer, save_method) ->
  subwidgets = _.map(array, widgetizer)
  list_edit_view = ListEditView(subwidgets)
  multi_view = MultiView([list_edit_view])
  elem = $("<div>")
  elem.append multi_view.current().element()
  save_link = $("<a href='#'>").html("save")
  save_link.click ->
    save_method self.value()
  elem.append save_link
  
  self =
    element: -> elem
    value: -> multi_view.current().value()
    
jQuery(document).ready ->
  save = (data) -> console.log data
  root = List(["hello", "world"], Atom, save)
  $("#content").append root.element()
  console.log root.value()