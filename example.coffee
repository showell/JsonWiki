jQuery(document).ready ->
  {Atom, Hash, List} = $.JsonWiki
  
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
        },
        {
          choice: "B",
          answer: "two",
          explanation: "still need to go higher"
        }
      ]
  
  default_answer = {
    choice: "choice",
    answer: "answer",
  }
  
  hash_schema =
    question: (question) -> Hash question,
      stimulus: Atom
      explanation: Atom
      answers: (answers) -> List answers, 
          widgetizer: (answer) -> Hash answer,
            choice: Atom
            answer: Atom
            explanation: Atom
          default_value: default_answer
  root_widget = Hash(data, hash_schema, save_method)

  $("#content").append root_widget.element()