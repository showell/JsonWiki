(function() {
  jQuery(document).ready(function() {
    var BooleanWidget, Hash, HashWidget, List, StringWidget, data, default_answer, hash_schema, root_widget, save_method, _ref;
    _ref = $.JsonWiki, StringWidget = _ref.StringWidget, BooleanWidget = _ref.BooleanWidget, Hash = _ref.Hash, List = _ref.List;
    save_method = function(data) {
      return alert("Saving data" + JSON.stringify(data, null, "    "));
    };
    data = {
      question: {
        stimulus: "How many fingers?",
        explanation: "Just count them",
        answers: [
          {
            choice: "A",
            answer: "one",
            explanation: "one is not enough",
            correct: false
          }, {
            choice: "B",
            answer: "five",
            explanation: "we count the thumb",
            correct: true
          }
        ]
      }
    };
    default_answer = {
      choice: "choice",
      answer: "answer",
      explanation: "explanation",
      correct: false
    };
    HashWidget = function(schema) {
      return function(obj) {
        return Hash(obj, schema);
      };
    };
    hash_schema = {
      question: HashWidget({
        stimulus: StringWidget,
        explanation: StringWidget,
        answers: function(answers) {
          return List(answers, {
            widgetizer: HashWidget({
              choice: StringWidget,
              answer: StringWidget,
              explanation: StringWidget,
              correct: BooleanWidget
            }),
            default_value: default_answer
          });
        }
      })
    };
    root_widget = Hash(data, hash_schema, save_method);
    return $("#content").append(root_widget.element());
  });
}).call(this);
