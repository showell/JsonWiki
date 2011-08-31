(function() {
  jQuery(document).ready(function() {
    var BooleanWidget, Hash, HashWidget, List, StringWidget, array_of_strings, create_example_link, example, examples, fraction_question, generic_preview_method, multiple_choice_question, preview_multiple_choice, preview_quantitative_comparison, quantitative_comparison, save_method, _i, _len, _ref, _results;
    _ref = $.JsonWiki, StringWidget = _ref.StringWidget, BooleanWidget = _ref.BooleanWidget, Hash = _ref.Hash, List = _ref.List;
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
    preview_multiple_choice = function(widget) {
      var data, template;
      data = widget.value();
      template = '{{#question}}\n  <h2>{{stimulus}}</h2>\n  <p>{{explanation}}</p>\n  {{#answers}}\n    <hr>\n    {{#correct}}<h3>Correct!</h3>{{/correct}}\n    {{choice}} - {{answer}}\n    <br>\n    {{explanation}}\n  {{/answers}}\n{{/question}}';
      console.log(Mustache.to_html(template, data));
      return $("#preview").html(Mustache.to_html(template, data));
    };
    quantitative_comparison = function() {
      var data, schema;
      data = {
        info: "Alice weighs less than Bob",
        quantity_A: "Twice Alice's weight",
        quantity_B: "Bob's Weight",
        correct_answer: "D",
        explanation: "<b>The correct answer is choice D.</b>\nWe cannot determine from the information given."
      };
      schema = {
        info: StringWidget,
        quantity_A: StringWidget,
        quantity_B: StringWidget,
        correct_answer: StringWidget,
        explanation: StringWidget
      };
      return Hash(data, schema, save_method);
    };
    preview_quantitative_comparison = function(widget) {
      var data, template;
      data = widget.value();
      template = '{{info}}\n<table border="1">\n  <tr>\n    <td>{{quantity_A}}</td>\n    <td>{{quantity_B}}</td>\n  </tr>\n</table>\n<h2>Correct Answer is {{correct_answer}}</h2>\n<p>{{{explanation}}}</p>';
      console.log(Mustache.to_html(template, data));
      return $("#preview").html(Mustache.to_html(template, data));
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
    array_of_strings = function() {
      var data, schema;
      data = ["apple", "banana", "carrot"];
      schema = {
        widgetizer: StringWidget,
        default_value: "new thingy"
      };
      return List(data, schema, save_method);
    };
    generic_preview_method = function(widget) {
      var json, pre;
      json = JSON.stringify(widget.value(), null, '  ');
      pre = $("<pre>").html(json);
      return $("#preview").html(pre);
    };
    examples = [
      {
        description: "Multiple Choice",
        method: multiple_choice_question,
        preview_method: preview_multiple_choice
      }, {
        description: "Quantitative Comparison",
        method: quantitative_comparison,
        preview_method: preview_quantitative_comparison
      }, {
        description: "Numeric Entry (fraction)",
        method: fraction_question,
        preview_method: generic_preview_method
      }, {
        description: "Array of Strings",
        method: array_of_strings,
        preview_method: generic_preview_method
      }
    ];
    save_method = function(data) {
      return alert("Saving data" + JSON.stringify(data, null, "    "));
    };
    create_example_link = function(example) {
      var a;
      a = $("<a href='#'>").html(example.description);
      a.click(function() {
        var content, preview_link, save_link, widget;
        $("#preview").empty();
        content = $("#content");
        content.empty();
        widget = example.method();
        save_link = $("<a href='#'>").html("save");
        save_link.click(function() {
          return save_method(widget.value());
        });
        content.append(save_link);
        preview_link = $("<a href='#'>").html("preview");
        preview_link.click(function() {
          return example.preview_method(widget);
        });
        content.append("&nbsp;");
        content.append(preview_link);
        return content.append(widget.element());
      });
      $("#menu").append(a);
      return $("#menu").append("<br />");
    };
    _results = [];
    for (_i = 0, _len = examples.length; _i < _len; _i++) {
      example = examples[_i];
      _results.push(create_example_link(example));
    }
    return _results;
  });
}).call(this);
