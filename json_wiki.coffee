Atom = (s) ->
  elem = $("<textarea>")
  elem.val(s)
  self =
    element: -> elem
    value: -> elem.val()
    
List = (array, widgetizer, save_method) ->
  subwidgets = _.map(array, widgetizer)
  elem = $("<div>")
  ul = $("<ul>")
  elem.append ul
  save_link = $("<a href='#'>").html("save")
  save_link.click ->
    save_method self.value()
  elem.append save_link
  
  for w in subwidgets
    li = $("<li>").html w.element()
    ul.append li
  self =
    element: -> elem
    value: -> _.map subwidgets, (w) -> w.value()
    
jQuery(document).ready ->
  save = (data) -> console.log data
  root = List(["hello", "world"], Atom, save)
  $("#content").append root.element()
  console.log root.value()