(function() {
  jQuery(document).ready(function() {
    var Atom, Hash, List, data, default_answer, root, save_method, schema, _ref;
    _ref = $.JsonWiki, Atom = _ref.Atom, Hash = _ref.Hash, List = _ref.List;
    save_method = function(data) {
      return console.log(JSON.stringify(data));
    };
    data = ["apple", "banana", "carrot"];
    default_answer = "fruit";
    schema = function(data) {
      return List(data, {
        widgetizer: Atom,
        default_value: default_answer,
        save_method: save_method
      });
    };
    root = schema(data);
    return $("#content").append(root.element());
  });
}).call(this);
