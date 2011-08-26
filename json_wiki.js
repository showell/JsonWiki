(function() {
  var Atom, List, ListEditView, MultiView;
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
  MultiView = function(widgets) {
    var self;
    return self = {
      current: function() {
        return widgets[0];
      }
    };
  };
  List = function(array, widgetizer, save_method) {
    var elem, list_edit_view, multi_view, save_link, self, subwidgets;
    subwidgets = _.map(array, widgetizer);
    list_edit_view = ListEditView(subwidgets);
    multi_view = MultiView([list_edit_view]);
    elem = $("<div>");
    elem.append(multi_view.current().element());
    save_link = $("<a href='#'>").html("save");
    save_link.click(function() {
      return save_method(self.value());
    });
    elem.append(save_link);
    return self = {
      element: function() {
        return elem;
      },
      value: function() {
        return multi_view.current().value();
      }
    };
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
