(function() {
  jQuery(document).ready(function() {
    var BooleanWidget, Hash, HashWidget, List, StringWidget, fraction_question, multiple_choice_question, save_method, _ref;
    _ref = $.JsonWiki, StringWidget = _ref.StringWidget, BooleanWidget = _ref.BooleanWidget, Hash = _ref.Hash, List = _ref.List;
    save_method = function(data) {
      return alert("Saving data" + JSON.stringify(data, null, "    "));
    };
    HashWidget = function(schema) {
      return function(obj) {
        return Hash(obj, schema);
      };
    };
    multiple_choice_question = function() {
      var data, default_answer, hash_schema;
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
      return Hash(data, hash_schema, save_method);
    };
    fraction_question = function() {
      var data, schema;
      data = {
        question: 'For the biological sciences and health sciences faculty combined, 1/3\nof the female and 2/9 of the male faculty members are tenured. Bla bla\nbla.',
        correct_answer: {
          numerator: "4",
          denominator: "15"
        },
        explanation: 'This is totally bogus proof of concept stuff.'
      };
      schema = {
        question: StringWidget,
        correct_answer: HashWidget({
          numerator: StringWidget,
          denominator: StringWidget
        }),
        explanation: StringWidget
      };
      return Hash(data, schema, save_method);
    };
    return $("#content").append(fraction_question().element());
  });
}).call(this);
