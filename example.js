(function() {
  jQuery(document).ready(function() {
    var Atom, Hash, List, data, default_answer, hash_schema, root_widget, save_method, _ref;
    _ref = $.JsonWiki, Atom = _ref.Atom, Hash = _ref.Hash, List = _ref.List;
    save_method = function(data) {
      return console.log(JSON.stringify(data));
    };
    data = {
      question: {
        stimulus: "How many fingers?",
        explanation: "Just count them",
        answers: [
          {
            choice: "A",
            answer: "one",
            explanation: "one is not enough"
          }, {
            choice: "B",
            answer: "two",
            explanation: "still need to go higher"
          }
        ]
      }
    };
    default_answer = {
      choice: "choice",
      answer: "answer"
    };
    hash_schema = {
      question: function(question) {
        return Hash(question, {
          stimulus: Atom,
          explanation: Atom,
          answers: function(answers) {
            return List(answers, {
              widgetizer: function(answer) {
                return Hash(answer, {
                  choice: Atom,
                  answer: Atom,
                  explanation: Atom
                });
              },
              default_value: default_answer
            });
          }
        });
      }
    };
    root_widget = Hash(data, hash_schema, save_method);
    return $("#content").append(root_widget.element());
  });
}).call(this);
