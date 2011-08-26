(function() {
  var Atom, List;
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
  List = function(array, widgetizer, save_method) {
    var elem, li, save_link, self, subwidgets, ul, w, _i, _len;
    subwidgets = _.map(array, widgetizer);
    elem = $("<div>");
    ul = $("<ul>");
    elem.append(ul);
    save_link = $("<a href='#'>").html("save");
    save_link.click(function() {
      return save_method(self.value());
    });
    elem.append(save_link);
    for (_i = 0, _len = subwidgets.length; _i < _len; _i++) {
      w = subwidgets[_i];
      li = $("<li>").html(w.element());
      ul.append(li);
    }
    return self = {
      element: function() {
        return elem;
      },
      value: function() {
        return _.map(subwidgets, function(w) {
          return w.value();
        });
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
