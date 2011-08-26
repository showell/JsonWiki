Atom = (s) ->
  elem = $("<textarea>")
  elem.val(s)
  self =
    element: -> elem
    value: -> elem.val()
    
ListRawView = (array) ->
  textarea = $("<textarea>").attr("rows", 10)
  textarea.html JSON.stringify(array, null, " ")
  self =
    element: -> textarea
    value: -> JSON.parse textarea.html()
    
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
  elem = $("<div>")
  subwidgets = _.map(array, widgetizer)
  multi_view = MultiView [
    ListRawView(array),
    ListEditView(subwidgets),
  ]

  self =
    element: -> elem
    value: -> multi_view.current().value()
    
  elem.append multi_view.current().element()
  create_save_link(self, save_method)  
  self
    
jQuery(document).ready ->
  save = (data) -> console.log data
  root = List(["hello", "world"], Atom, save)
  $("#content").append root.element()
  console.log root.value()