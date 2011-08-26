<p>
This doc describes a wiki for editing generalized data.
<p>
All objects can be shown in several modes:

* raw edit
* raw render
* styled edit
* styled render
* expanded or collapsed

<p>
All objects must conform to one of the following structures:

* atom
* list
* hash

<p>
All data gets persisted:

* all changes are inherently persisted locally
* some objects are only persisted through their parents
* hitting SAVE results in data being published to a remote source

<p>
All objects are addressable.  Examples:

* ["readme.txt"]
* ["questions", 1, "answers", "a"]
* ["departments", "accounting", "employees", "bob"]

<p>
All objects support these methods, with defaults provided for most:

* save
* raw_edit
* modify
* value
* view
* expand
* collapse
* refresh_from_remote
* search
* add_item
* fetch
* element

