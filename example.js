(function() {
  jQuery(document).ready(function() {
    var Atom, Hash, List, data, default_answer, root, save_method, schema, _ref;
    _ref = $.JsonWiki, Atom = _ref.Atom, Hash = _ref.Hash, List = _ref.List;
    save_method = function(data) {
      return console.log(JSON.stringify(data));
    };
    data = {
      answers: [
        {
          choice: "A",
          answer: "one"
        }, {
          choice: "B",
          answer: "two"
        }
      ]
    };
    default_answer = {
      choice: "choice",
      answer: "answer"
    };
    schema = function(data) {
      return Hash(data, {
        answers: function(answers) {
          return List(answers, {
            widgetizer: function(answer) {
              return Hash(answer, {
                choice: Atom,
                answer: Atom
              });
            },
            default_value: default_answer,
            save_method: save_method
          });
        }
      });
    };
    root = schema(data);
    return $("#content").append(root.element());
  });
}).call(this);
