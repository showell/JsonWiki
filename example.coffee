jQuery(document).ready ->
  {Atom, Hash, List} = $.JsonWiki
  
  save_method = (data) -> console.log JSON.stringify data
  
  data = [
    {
      choice: "A",
      answer: "one",
    },
    {
      choice: "B",
      answer: "two",
    }
  ]
  
  default_answer = {
    choice: "choice",
    answer: "answer",
  }
  
  schema = (data) ->
    List data, 
      widgetizer: (hash) -> Hash hash,
        choice: Atom
        answer: Atom
      default_value: default_answer
      save_method: save_method
  
  # data = {
  #   question:
  #     stimulus: "How many fingers?"
  #     explanation: "Just count them"
  #     answers: [
  #       {
  #         choice: "A"
  #         answer: "one"
  #         correct: "false"
  #         explanation: "one is not enough"
  #       },
  #       {
  #         choice: "B"
  #         answer: "five"
  #         correct: "true"
  #         explanation: "count em"
  #       }
  #     ]
  # }
  # simple_text =
  #   default: ''
  #   widgetizer: Atom
  # simple_hash = (schema) ->
  #   default: {}
  #   widgetizer: (h) -> Hash h, schema
  # simple_list = (schema) ->
  #   default: []
  #   widgetizer: (answers) -> List answers, schema
  #      
  # schema = (data) ->
  #   Hash data,
  #     question:
  #       simple_hash(
  #         stimulus: simple_text
  #         explanation: simple_text
  #         answers:
  #           simple_list (answer) -> Hash answer,
  #             choice: simple_text
  #             answer: simple_text
  #             correct: simple_text
  #             explanation: simple_text
  #       )
  #     save
  root = schema(data)
  $("#content").append root.element()