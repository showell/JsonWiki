jQuery(document).ready ->
  {StringWidget, BooleanWidget, Hash, List} = $.JsonWiki
  
  save_method = (data) ->
    alert "Saving data" + JSON.stringify data, null, "    "

  HashWidget = (schema) -> (obj) -> Hash obj, schema
  
  multiple_choice_question = ->
    data =
      question:
        stimulus: "How many fingers?"
        explanation: "Just count them"
        answers: [
          {
            choice: "A",
            answer: "one",
            explanation: "one is not enough"
            correct: false
          },
          {
            choice: "B",
            answer: "five",
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
    
  $("#content").append fraction_question().element()