(function() {
  var BooleanWidget, Hash, List, StringWidget, autosize_textarea, hash_to_table, make_insert_link, set_callbacks, table_to_hash;
  autosize_textarea = function(textarea, s) {
    var max_col, row, rows, _i, _len;
    rows = s.split("\n");
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
  StringWidget = function(s) {
    var div, self, textarea;
    if (s == null) {
      s = "";
    }
    div = $("<div>");
    div.append("<br />");
    textarea = $("<textarea>");
    div.append(textarea);
    self = {
      element: function() {
        return div;
      },
      value: function() {
        return textarea.val();
      },
      set: function(s) {
        textarea.val(s);
        return autosize_textarea(textarea, s);
      }
    };
    self.set(s);
    return self;
  };
  BooleanWidget = function(bool) {
    var elem, self;
    bool = !!bool;
    elem = $("<input type='checkbox'>");
    self = {
      element: function() {
        return elem;
      },
      value: function() {
        return !!elem.prop("checked");
      },
      set: function(bool) {
        return elem.prop("checked", bool);
      }
    };
    self.set(bool);
    return self;
  };
  Hash = function(hash, widgetizer) {
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
  List = function(array, options) {
    var default_value, insert_links, save_method, self, subwidgets, ul, widgetizer;
    widgetizer = options.widgetizer, default_value = options.default_value, save_method = options.save_method;
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
        var index, link, w, _len, _results;
        ul.empty();
        subwidgets = _.map(array, widgetizer);
        insert_links = [];
        link = make_insert_link(self, 0);
        insert_links.push(link);
        ul.append(link.element);
        _results = [];
        for (index = 0, _len = subwidgets.length; index < _len; index++) {
          w = subwidgets[index];
          ul.append(self.wrap(w));
          link = make_insert_link(self, index + 1);
          insert_links.push(link);
          _results.push(ul.append(link.element));
        }
        return _results;
      },
      wrap: function(w) {
        var li;
        li = $("<li>").html(w.element());
        li.attr("class", "ListWidgetItem");
        return li;
      },
      insert_element_at_index: function(index) {
        var i, insert_link, li, link, new_element, new_li, _len, _results;
        new_element = self.new_element(index);
        li = $(ul.children()[index * 2]);
        new_li = self.wrap(new_element);
        li.after(new_li);
        link = make_insert_link(self, index + 1);
        insert_links.splice(index + 1, 0, link);
        new_li.after(link.element);
        _results = [];
        for (i = 0, _len = insert_links.length; i < _len; i++) {
          insert_link = insert_links[i];
          _results.push(insert_link.set(i));
        }
        return _results;
      },
      new_element: function(index) {
        var widget;
        widget = widgetizer(default_value);
        subwidgets.splice(index, 0, widget);
        return widget;
      }
    };
    self.set(array);
    return self;
  };
  make_insert_link = function(widget, index) {
    var a, li, self;
    li = $("<li>");
    a = $("<a href='#'>");
    li.append(a);
    a.click(function() {
      return widget.insert_element_at_index(index);
    });
    self = {
      set: function(idx) {
        index = index;
        return a.html("insert element " + index);
      },
      element: li
    };
    self.set(index);
    return self;
  };
  $.JsonWiki = {
    Hash: Hash,
    List: List,
    StringWidget: StringWidget,
    BooleanWidget: BooleanWidget
  };
}).call(this);
