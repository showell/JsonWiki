(function() {
  jQuery(document).ready(function() {
    var Atom, Hash, List, data, root, save, schema, simple_hash, simple_list, simple_text, _ref;
    _ref = $.JsonWiki, Atom = _ref.Atom, Hash = _ref.Hash, List = _ref.List;
    save = function(data) {
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
            correct: "false",
            explanation: "one is not enough"
          }, {
            choice: "B",
            answer: "five",
            correct: "true",
            explanation: "count em"
          }
        ]
      }
    };
    simple_text = {
      "default": '',
      widgetizer: Atom
    };
    simple_hash = function(schema) {
      return {
        "default": {},
        widgetizer: function(h) {
          return Hash(h, schema);
        }
      };
    };
    simple_list = function(schema) {
      return {
        "default": [],
        widgetizer: function(answers) {
          return List(answers, schema);
        }
      };
    };
    schema = function(data) {
      return Hash(data, {
        question: simple_hash({
          stimulus: simple_text,
          explanation: simple_text,
          answers: simple_list(function(answer) {
            return Hash(answer, {
              choice: simple_text,
              answer: simple_text,
              correct: simple_text,
              explanation: simple_text
            });
          })
        })
      }, save);
    };
    root = schema(data);
    return $("#content").append(root.element());
  });
}).call(this);
