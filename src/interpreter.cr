class Interpreter
  def initialize
  end

  def repl
    loop do
      print "$> "
      i = gets
      if i == "exit"
        return
      end
      rs = self.eval i.not_nil!
      rs.each do |r|
        puts "#=> #{r.colorize(:yellow)}"
      end
    end
  end

  def eval(source : String)
    results = [] of Int64 | Float64
    lexer = Lexer.new source
    tokens = lexer.consume
    if lexer.errors.any?
      eprt = ErrorReporter.new source.split('\n')
      eprt.report(lexer)
      return results
    end
    parser = Parser.new tokens
    exps = parser.parse
    if parser.errors.any?
      eprt = ErrorReporter.new source.split('\n')
      eprt.report(parser)
      return results
    end
    exps.each do |expression|
      results << expression.eval
    end
    results
  end
end
