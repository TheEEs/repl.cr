require "colorize"

class ErrorReporter
  def initialize(@source_lines : Array(String))
  end

  def report(e : SyntaxError)
    m = e.message
    t = e.token
    puts @source_lines[t.line - 1].colorize(:yellow)
    if m
      puts "Syntax Error(line #{t.line}, column #{t.column}):#{m}"
    else
      puts "Syntax Error(line #{t.line}, column #{t.column}): Unexpected character #{t.value.colorize(:yellow)}"
    end
  end

  def report(l : Lexer | Parser)
    l.errors.each do |e|
      self.report e
    end
  end
end
