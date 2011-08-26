(function() {
  var Atom, List, ListEditView, ListRawView, MultiView, create_save_link, create_toggle_link;
  Atom = function(s) {
    var elem, self;
    elem = $("<textarea>");
    self = {
      element: function() {
        return elem;
      },
      value: function() {
        return elem.val();
      },
      set: function(s) {
        return elem.val(s);
      }
    };
    self.set(s);
    return self;
  };
  ListRawView = function(array) {
    var div, self, textarea;
    div = $("<div>");
    textarea = $("<textarea>").attr("rows", 10);
    textarea.css("font-size", "15px");
    div.append(textarea);
    self = {
      element: function() {
        return div;
      },
      value: function() {
        return JSON.parse(textarea.val());
      },
      set: function(array) {
        return textarea.val(JSON.stringify(array, null, " "));
      }
    };
    self.set(array);
    return self;
  };
  ListEditView = function(array, widgetizer) {
    var self, subwidgets, ul;
    ul = $("<ul>");
    subwidgets = [];
    self = {
      element: function() {
        return ul;
      },
      value: function() {
        return _.map(subwidgets, function(w) {
          return w.value();
        });
      },
      set: function(array) {
        var li, w, _i, _len, _results;
        ul.empty();
        subwidgets = _.map(array, widgetizer);
        _results = [];
        for (_i = 0, _len = subwidgets.length; _i < _len; _i++) {
          w = subwidgets[_i];
          li = $("<li>").html(w.element());
          _results.push(ul.append(li));
        }
        return _results;
      }
    };
    self.set(array);
    return self;
  };
  create_toggle_link = function(parent, toggle) {
    var toggle_link;
    toggle_link = $("<a href='#'>").html("toggle");
    toggle_link.click(toggle);
    parent.prepend(toggle_link);
    return parent.prepend(' ');
  };
  MultiView = function(parent, widgets) {
    var curr, div, index, self, widget, _i, _len;
    div = $("<div>");
    parent.append(div);
    parent = div;
    index = 0;
    curr = widgets[0];
    self = {
      value: function() {
        return curr.value();
      },
      toggle: function() {
        var val;
        curr.element().hide();
        val = curr.value();
        index = (index + 1) % widgets.length;
        curr = widgets[index];
        curr.set(val);
        return curr.element().show();
      }
    };
    console.log(widgets);
    for (_i = 0, _len = widgets.length; _i < _len; _i++) {
      widget = widgets[_i];
      widget.element().hide();
      parent.append(widget.element());
    }
    widgets[0].element().show();
    create_toggle_link(parent, self.toggle);
    return self;
  };
  create_save_link = function(widget, save_method) {
    var elem, save_link;
    save_link = $("<a href='#'>").html("save");
    save_link.click(function() {
      return save_method(widget.value());
    });
    elem = widget.element();
    elem.append(' ');
    return elem.append(save_link);
  };
  List = function(array, widgetizer, save_method) {
    var elem, multi_view, self;
    elem = $("<div>");
    self = {
      element: function() {
        return elem;
      },
      value: function() {
        return multi_view.value();
      },
      append: function(subelem) {
        return elem.append(subelem);
      }
    };
    multi_view = MultiView(self, [ListEditView(array, widgetizer), ListRawView(array)]);
    if (save_method) {
      create_save_link(self, save_method);
    }
    return self;
  };
  jQuery(document).ready(function() {
    var data, root, save, schema;
    save = function(data) {
      return console.log(data);
    };
    data = [["hello", "world"], ["yo"]];
    schema = function(sublist) {
      return List(sublist, Atom);
    };
    root = List(data, schema, save);
    $("#content").append(root.element());
    return console.log(root.value());
  });
}).call(this);
