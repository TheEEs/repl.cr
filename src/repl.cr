require "./exp_parser"
{% if flag?(:repl) %}
  repl = Interpreter.new
  repl.repl
{% end %}
