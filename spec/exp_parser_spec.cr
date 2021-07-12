require "./spec_helper"

describe Lexer do
  it "works" do
    input = "100*(3+2)**5"
    l = Lexer.new(input)
    ts = l.consume
    ts.map(&.value).should eq ["100", "*", "(", "3", "+", "2", ")", "**", "5", ";"]
  end

  it "works" do
    input = "100 *  (3+  2) * * 5"
    l = Lexer.new(input)
    ts = l.consume
    ts.map(&.value).should eq ["100", "*", "(", "3", "+", "2", ")", "*", "*", "5", ";"]
  end

  it "works" do
    input = "100 *  (3+  2) ** 5"
    l = Lexer.new(input)
    ts = l.consume
    ts.map(&.value).should eq ["100", "*", "(", "3", "+", "2", ")", "**", "5", ";"]
  end

  it "works" do
    input = "100 *  (3 +  2) *** 5"
    l = Lexer.new(input)
    ts = l.consume
    ts.map(&.value).should eq ["100", "*", "(", "3", "+", "2", ")", "**", "*", "5", ";"]
  end

  context "wrong cases" do
    it "" do
      input = "axb + 100"
      l = Lexer.new input
      ts = l.consume
      l.errors.size.should eq 3
    end
  end
end

describe Parser do
  it "works" do
    input = "100 + 3 * 2"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    output = p.puts_pathen
    output.should eq "(100+(3*2))"
  end

  it "works" do
    input = "100 * 3 * 2"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    output = p.puts_pathen
    output.should eq "((100*3)*2)"
  end

  it "works" do
    input = "100 + 3 - 2"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    output = p.puts_pathen
    output.should eq "((100+3)-2)"
  end

  it "works" do
    input = "100 + 3 / 2"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    output = p.puts_pathen
    output.should eq "(100+(3/2))"
  end

  it "works" do
    input = "100 ** 3 ** 2"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    output = p.puts_pathen
    output.should eq "(100**(3**2))"
  end

  it "works" do
    input = "100 - (3+2)"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    output = p.puts_pathen
    output.should eq "(100-(3+2))"
  end

  it "works" do
    input = "100 * 3 + 2 / 6 ** 3"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    output = p.puts_pathen
    output.should eq "((100*3)+(2/(6**3)))"
  end

  it "do not show any exception" do
    input = "100 + 4"
    l = Lexer.new(input)
    tokens = l.consume
    p = Parser.new tokens
    p.errors.any?.should be_falsey
  end

  context "wrong cases" do
    it "shows one syntax errors" do
      input = "1  3"
      l = Lexer.new(input)
      tokens = l.consume
      p = Parser.new tokens
      output = p.parse
      p.errors.size.should eq 1
    end

    it "shows an syntax error" do
      input = "100 +; 4; 4"
      l = Lexer.new(input)
      tokens = l.consume
      p = Parser.new tokens
      p.parse
      p.errors.size.should eq 1
    end

    it "shows 3 syntax errors" do
      input = "100+;4 4** "
      l = Lexer.new(input)
      tokens = l.consume
      p = Parser.new tokens
      p.parse
      p.errors.size.should eq 3
    end
  end
end

describe ErrorReporter do
  it "works" do
    input = "
100 a
b
;4 4**
    "
    l = Lexer.new(input)
    tokens = l.consume
    l.errors.any?.should be_truthy
    er = ErrorReporter.new input.split('\n')
    er.report(l)
  end
end

describe Interpreter do
  it "works" do
    input = "1+ 5"
    i = Interpreter.new
    r = i.eval(input)
    r.first.should eq 6
  end

  it "works" do
    input = "1+ 5; 5 **2; 2 * 2 ** (7 + 1)"
    i = Interpreter.new
    r = i.eval(input)
    r.should eq [6, 25, 512]
  end
end
