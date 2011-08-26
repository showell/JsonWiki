<p>
This doc describes a wiki for editing generalized data.
<p>
All data can be shown in several modes:

* raw edit
* raw render
* styled edit
* styled render
* expanded or collapsed

<p>
All data must conform to one of the following structures:

* string
* list
* hash

<p>
All data gets persisted:

* all changes are inherently persisted locally
* some objects are only persisted through their parents
* hitting SAVE results in data being published to a remote source

<p>
All data is addressable.  Examples:

* ["readme.txt"]
* ["questions", 1, "answers", "a"]
* ["departments", "accounting", "employees", "bob"]

