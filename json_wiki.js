(function() {
  var Atom, Hash, HashEditView, JsonRawView, List, ListEditView, MultiView, create_save_link, create_toggle_link, hash_to_table, set_callbacks, table_to_hash;
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
  JsonRawView = function(array) {
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
  HashEditView = function(hash, widgetizer) {
    var div, self, table;
    table = $("<table>");
    div = $("<div>");
    self = {
      element: function() {
        return div;
      },
      set: function(hash) {
        hash_to_table(table, hash, widgetizer);
        return div.append(table);
      },
      value: function() {
        return table_to_hash(table);
      }
    };
    self.set(hash);
    return self;
  };
  table_to_hash = function(table) {
    var hash;
    hash = {};
    table.find("tr").each(function(index, tr) {
      var key, value;
      tr = $(tr);
      key = (tr.data("get_key"))();
      value = (tr.data("get_value"))();
      return hash[key] = value;
    });
    return hash;
  };
  set_callbacks = function(tr, widget) {
    tr.data("get_key", function() {
      return tr.find(".key").html();
    });
    return tr.data("get_value", function() {
      return widget.value();
    });
  };
  hash_to_table = function(table, hash, widgetizer) {
    var key, td_key, td_value, tr, value, widget;
    table.empty();
    for (key in hash) {
      value = hash[key];
      td_key = $("<td class='key'>");
      td_value = $("<td class='value'>");
      td_key.html(key);
      widget = widgetizer[key].widgetizer(value);
      td_value.html(widget.element());
      tr = $("<tr>");
      set_callbacks(tr, widget);
      table.append(tr);
      tr.append(td_key);
      tr.append(td_value);
    }
    return table;
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
  Hash = function(hash, widgetizer, save_method) {
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
    multi_view = MultiView(self, [HashEditView(hash, widgetizer), JsonRawView(hash)]);
    if (save_method) {
      create_save_link(self, save_method);
    }
    return self;
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
    multi_view = MultiView(self, [ListEditView(array, widgetizer), JsonRawView(array)]);
    if (save_method) {
      create_save_link(self, save_method);
    }
    return self;
  };
  jQuery(document).ready(function() {
    var data, root, save, schema;
    save = function(data) {
      return console.log(JSON.stringify(data));
    };
    data = [
      {
        name: "alice",
        salary: "100",
        friends: ["bob", "cal"]
      }, {
        name: "bob",
        salary: "500",
        friends: ["alice", "cal"]
      }
    ];
    schema = function(data) {
      return List(data, function(sublist) {
        return Hash(sublist, {
          name: {
            widgetizer: Atom,
            "default": ''
          },
          salary: {
            widgetizer: Atom,
            "default": [0]
          },
          friends: {
            widgetizer: function(array) {
              return List(array, Atom);
            },
            "default": []
          }
        });
      }, save);
    };
    root = schema(data);
    return $("#content").append(root.element());
  });
}).call(this);
