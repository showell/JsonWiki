jQuery(document).ready ->
  {Atom, BooleanWidget, Hash, List} = $.JsonWiki
  
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
    choice: "choice",
    answer: "answer",
  }
  
  HashWidget = (schema) -> (obj) -> Hash obj, schema
  
  hash_schema =
    question: HashWidget
      stimulus: Atom
      explanation: Atom
      answers: (answers) -> List answers, 
          widgetizer: HashWidget
            choice: Atom
            answer: Atom
            explanation: Atom
            correct: BooleanWidget
          default_value: default_answer
  root_widget = Hash(data, hash_schema, save_method)

  $("#content").append root_widget.element()