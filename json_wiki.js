(function() {
  var Atom, List, ListEditView, ListRawView, MultiView, create_save_link, create_toggle_link;
  Atom = function(s) {
    var elem, self;
    elem = $("<textarea>");
    elem.val(s);
    return self = {
      element: function() {
        return elem;
      },
      value: function() {
        return elem.val();
      }
    };
  };
  ListRawView = function(array) {
    var div, self, textarea;
    div = $("<div>");
    textarea = $("<textarea>").attr("rows", 10);
    textarea.html(JSON.stringify(array, null, " "));
    div.append(textarea);
    return self = {
      element: function() {
        return div;
      },
      value: function() {
        return JSON.parse(textarea.html());
      }
    };
  };
  ListEditView = function(subwidgets) {
    var li, self, ul, w, _i, _len;
    ul = $("<ul>");
    for (_i = 0, _len = subwidgets.length; _i < _len; _i++) {
      w = subwidgets[_i];
      li = $("<li>").html(w.element());
      ul.append(li);
    }
    return self = {
      element: function() {
        return ul;
      },
      value: function() {
        return _.map(subwidgets, function(w) {
          return w.value();
        });
      }
    };
  };
  create_toggle_link = function(parent, toggle) {
    var toggle_link;
    toggle_link = $("<a href='#'>").html("toggle");
    toggle_link.click(toggle);
    parent.append(' ');
    return parent.append(toggle_link);
  };
  MultiView = function(parent, widgets) {
    var div, index, self, widget, _i, _len;
    div = $("<div>");
    parent.append(div);
    parent = div;
    index = 0;
    self = {
      current: function() {
        return widgets[index];
      },
      toggle: function() {
        var val;
        self.current().element().hide();
        val = self.current().value();
        index = (index + 1) % widgets.length;
        return self.current().element().show();
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
    var elem, multi_view, self, subwidgets;
    elem = $("<div>");
    subwidgets = _.map(array, widgetizer);
    self = {
      element: function() {
        return elem;
      },
      value: function() {
        return multi_view.current().value();
      },
      append: function(subelem) {
        return elem.append(subelem);
      }
    };
    multi_view = MultiView(self, [ListRawView(array), ListEditView(subwidgets)]);
    create_save_link(self, save_method);
    return self;
  };
  jQuery(document).ready(function() {
    var root, save;
    save = function(data) {
      return console.log(data);
    };
    root = List(["hello", "world"], Atom, save);
    $("#content").append(root.element());
    return console.log(root.value());
  });
}).call(this);
