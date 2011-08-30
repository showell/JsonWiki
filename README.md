<p>
This doc describes a generalized editor for JSON-like data.
<p>
Assume your JSON objects are tree-like widgets built from hashes, arrays, and primitives. 
<p>
All objects can be editing with a recursive widget:

* hashes map to HTML tables
* lists map to HTML lists
* primitives map to HTML primitives like textarea, checkboxes etc.

<p>
To make a generalized editor, you want "branch widgets" to be composed from arbitrary "child widgets,"
which can be branches themselves, or leaves.

<p>
All widgets support a simple and consisent API:
* (construction)
* element
* value
<p>
All your programming effort can focus on the trickier branch elements:
* arrays need insert/delete
* some hashes can be modeled as simple HTML tables  
* if hash keys are dynamic, then you need to support insert/delete
<p>
If the widgets are robust for arrays and hashing, you can plug in all kinds of leaf widgets, as long as those widgets
are either built to play nice with the branch widgets.  If leaf widgets don't play nice out of the box, it's simple to wrap
them.  

<p>
Everything else should be decoupled from your basic editor:
* saving - let the persistence layer handle
* preview - have a separate preview method