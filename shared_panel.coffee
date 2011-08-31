# This is just a gate for writing content to the #shared_panel div.  It allows callers
# to register a callback function if they 
$.SharedPanel =
  self =
    html: (html) ->
      $("#shared_panel").html html
      # call back to previous person and let them clean up
    empty: ->
      $("#shared_panel").empty()