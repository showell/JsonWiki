(function() {
  var Atom, Hash, HashEditView, JsonRawView, List, ListEditView, MultiView, add_insert_link, autosize_textarea, create_save_link, create_toggle_link, hash_to_table, set_callbacks, table_to_hash;
  Atom = function(s) {
    var elem, self;
    if (s == null) {
      s = "";
    }
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
  autosize_textarea = function(textarea, json) {
    var max_col, row, rows, _i, _len;
    rows = json.split("\n");
    textarea.attr("rows", rows.length + 2);
    max_col = 0;
    for (_i = 0, _len = rows.length; _i < _len; _i++) {
      row = rows[_i];
      if (row.length > max_col) {
        max_col = row.length;
      }
    }
    return textarea.attr("cols", max_col);
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
        var json;
        json = JSON.stringify(array, null, " ");
        textarea.val(json);
        try {
          return autosize_textarea(textarea, json);
        } catch (e) {

        }
      }
    };
    self.set(array);
    return self;
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
  HashEditView = function(hash, widgetizer) {
    var div, self, table, trs;
    table = $("<table>");
    div = $("<div>");
    trs = [];
    self = {
      element: function() {
        return div;
      },
      set: function(hash) {
        trs = hash_to_table(table, hash, widgetizer);
        return div.append(table);
      },
      value: function() {
        return table_to_hash(trs);
      }
    };
    self.set(hash);
    return self;
  };
  table_to_hash = function(trs) {
    var hash, key, tr, value, _i, _len;
    hash = {};
    for (_i = 0, _len = trs.length; _i < _len; _i++) {
      tr = trs[_i];
      key = (tr.data("get_key"))();
      value = (tr.data("get_value"))();
      hash[key] = value;
    }
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
    var key, td_key, td_value, tr, trs, value, widget;
    table.empty();
    trs = [];
    for (key in hash) {
      value = hash[key];
      td_key = $("<th class='key'>").css("text-align", "left");
      td_value = $("<td class='value'>");
      td_key.html(key);
      widget = widgetizer[key](value);
      td_value.html(widget.element());
      tr = $("<tr valign='top'>");
      trs.push(tr);
      set_callbacks(tr, widget);
      table.append(tr);
      tr.append(td_key);
      tr.append(td_value);
    }
    return trs;
  };
  add_insert_link = function(widget, index) {
    var a, li, self;
    li = $("<li>");
    a = $("<a href='#'>").html("insert");
    li.append(a);
    a.click(function() {
      var new_element;
      new_element = widget.new_element(index);
      return widget.update_links(new_element, index);
    });
    return self = {
      set: function(idx) {
        return index = index;
      },
      element: li
    };
  };
  ListEditView = function(array, widgetizer, default_value) {
    var insert_links, self, subwidgets, ul;
    ul = $("<ul>");
    subwidgets = [];
    insert_links = [];
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
        var index, li, link, w, _len, _results;
        ul.empty();
        subwidgets = _.map(array, widgetizer);
        link = add_insert_link(self, 0);
        insert_links.push(link);
        ul.append(link.element);
        _results = [];
        for (index = 0, _len = subwidgets.length; index < _len; index++) {
          w = subwidgets[index];
          li = $("<li>").html(w.element());
          ul.append(li);
          link = add_insert_link(self, index + 1);
          insert_links.push(link);
          _results.push(ul.append(link.element));
        }
        return _results;
      },
      update_links: function(element, index) {
        var i, insert_link, li, link, _len, _results;
        li = $(ul.children()[index * 2]);
        li.after(element.element());
        link = add_insert_link(self, index + 1);
        insert_links.push(link);
        element.element().after(link.element);
        _results = [];
        for (i = 0, _len = insert_links.length; i < _len; i++) {
          insert_link = insert_links[i];
          _results.push(insert_link.set(i));
        }
        return _results;
      },
      new_element: function(index) {
        var widget;
        console.log("new_element", default_value);
        widget = widgetizer(default_value);
        subwidgets.splice(index, 0, widget);
        return widget;
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
        try {
          val = curr.value();
        } catch (e) {
          alert(e);
          return;
        }
        curr.element().hide();
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
  List = function(array, options) {
    var default_value, elem, multi_view, save_method, self, widgetizer;
    widgetizer = options.widgetizer, default_value = options.default_value, save_method = options.save_method;
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
    multi_view = MultiView(self, [ListEditView(array, widgetizer, default_value), JsonRawView(array)]);
    if (save_method) {
      create_save_link(self, save_method);
    }
    return self;
  };
  $.JsonWiki = {
    Hash: Hash,
    List: List,
    Atom: Atom
  };
}).call(this);
