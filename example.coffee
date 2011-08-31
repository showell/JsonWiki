jQuery(document).ready ->
  {StringWidget, BooleanWidget, Hash, List} = $.JsonWiki
  
  HashWidget = (schema) -> (obj) -> Hash obj, schema
  

  multiple_choice_question = ->
    data =
      question:
        stimulus: "How many fingers?"
        explanation: "Just count them"
        answers: [
          {
            choice: "A",
            answer: "one"
            explanation: "one is not enough"
            correct: false
          },
          {
            choice: "B",
            answer: "five"
            explanation: "we count the thumb"
            correct: true
          }
        ]
  
    default_answer = {
      choice: "choice"
      answer: "answer"
      explanation: "explanation"
      correct: false
    }
  
    hash_schema =
      question: HashWidget
        stimulus: StringWidget
        explanation: StringWidget
        answers: (answers) -> List answers, 
            widgetizer: HashWidget
              choice: StringWidget
              answer: StringWidget
              explanation: StringWidget
              correct: BooleanWidget
            default_value: default_answer
    Hash(data, hash_schema, save_method)

  preview_multiple_choice = (widget) ->
    data = widget.value()
    template = '''
      {{#question}}
        <h2>{{stimulus}}</h2>
        <p>{{explanation}}</p>
        {{#answers}}
          <hr>
          {{#correct}}<h3>Correct!</h3>{{/correct}}
          {{choice}} - {{answer}}
          <br>
          {{explanation}}
        {{/answers}}
      {{/question}}
    '''
    console.log Mustache.to_html(template, data)
    $("#preview").html Mustache.to_html(template, data)
  
  quantitative_comparison = ->
    data =
      info: "Alice weighs less than Bob"
      quantity_A: "Twice Alice's weight"
      quantity_B: "Bob's Weight"
      correct_answer: "D"
      explanation: """
        <b>The correct answer is choice D.</b>
        We cannot determine from the information given.
        """
      
    schema =
      info: StringWidget
      quantity_A: StringWidget
      quantity_B: StringWidget
      correct_answer: StringWidget
      explanation: StringWidget 
    Hash(data, schema, save_method)

  preview_quantitative_comparison = (widget) ->
    data = widget.value()
    template = '''
      {{info}}
      <table border="1">
        <tr>
          <td>{{quantity_A}}</td>
          <td>{{quantity_B}}</td>
        </tr>
      </table>
      <h2>Correct Answer is {{correct_answer}}</h2>
      <p>{{{explanation}}}</p>
    '''
    console.log Mustache.to_html(template, data)
    $("#preview").html Mustache.to_html(template, data)
    
      
  fraction_question = ->
    data =
      question: '''
        For the biological sciences and health sciences faculty combined, 1/3
        of the female and 2/9 of the male faculty members are tenured. Bla bla
        bla.'''
      correct_answer:
        numerator: "4"
        denominator: "15"
      explanation: '''
        This is totally bogus proof of concept stuff.
        '''
    schema =
      question: StringWidget
      correct_answer: HashWidget
        numerator: StringWidget
        denominator: StringWidget
      explanation: StringWidget
      
    Hash(data, schema, save_method)

  array_of_strings = ->
    data = ["apple", "banana", "carrot"]
    schema =
      widgetizer: StringWidget
      default_value: "new thingy"
    List(data, schema, save_method)

  generic_preview_method = (widget) ->
    json = JSON.stringify widget.value(), null, '  '
    pre = $("<pre>").html json
    $("#preview").html pre
    

  examples = [
    {
      description: "Multiple Choice"
      method: multiple_choice_question
      preview_method: preview_multiple_choice
    },
    {
      description: "Quantitative Comparison"
      method: quantitative_comparison
      preview_method: preview_quantitative_comparison
    },
    {
      description: "Numeric Entry (fraction)"
      method: fraction_question
      preview_method: generic_preview_method
    },
    {
      description: "Array of Strings"
      method: array_of_strings
      preview_method: generic_preview_method
    },
  ]
  
  save_method = (data) ->
    alert "Saving data" + JSON.stringify data, null, "    "

  create_example_link = (example) ->
    a = $("<a href='#'>").html(example.description)
    a.click ->
      $("#preview").empty()
      content = $("#content")
      content.empty()
      widget = example.method()
      save_link = $("<a href='#'>").html("save")
      save_link.click ->
        save_method widget.value()
      content.append save_link
      preview_link = $("<a href='#'>").html("preview")
      preview_link.click ->
        example.preview_method(widget)
      content.append "&nbsp;"
      content.append preview_link
      content.append widget.element()
    $("#menu").append(a)
    $("#menu").append "<br />"
  
  for example in examples
    create_example_link(example)
  
