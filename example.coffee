jQuery(document).ready ->
  {Atom, Hash, List} = $.JsonWiki
  
  save_method = (data) -> console.log JSON.stringify data
  
  data = [
    "apple",
    "banana",
    "carrot"
  ]
  
  default_value = "fruit"
  
  schema = (data) ->
    List data, Atom, default_value, save_method
  
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