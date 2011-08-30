jQuery(document).ready ->
  {StringWidget, BooleanWidget, Hash, List} = $.JsonWiki
  
  save_method = (data) -> console.log JSON.stringify data
  
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
  
  HashWidget = (schema) -> (obj) -> Hash obj, schema
  
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
  root_widget = Hash(data, hash_schema, save_method)

  $("#content").append root_widget.element()