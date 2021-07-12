class Parser
  property errors = [] of SyntaxError

  def initialize(@tokens : Array(Token))
    @index = 0
  end

  def parse
    expressions = [] of ASTNode
    while @index < @tokens.size
      expressions << expression
    end
    expressions
  end

  def puts_pathen
    tree = term
    tree.try &.group_by_pathenese
  end

  def expression
    t = term
    s = match?(";", "\n")
    if s.nil?
      errors << SyntaxError.new "Expect a new line or semicolon", current_token
    end
    t
  end

  def term
    e = self.factor
    while s = self.match?("+", "-")
      e = ASTNode::Term.new left: e, right: self.factor, sign: s.value
    end
    e
  end

  def factor
    e = self.exponent
    while s = self.match?("*", "/")
      e = ASTNode::Factor.new left: e, right: self.exponent, sign: s.value
    end
    e
  end

  def exponent
    e = self.unary
    while self.match?("**")
      e = ASTNode::Exponent.new left: e, right: self.exponent
    end
    e
  end

  def unary
    if s = self.match?("+", "-")
      ASTNode::Unary.new sign: s.value, right: self.pathen
    else
      self.pathen
    end
  end

  def pathen
    o = self.match?("(")
    if o
      e = self.term
      self.match(")")
      return e
    else
      self.number
    end
  end

  def number
    e = self.get(TokenType::NUMBER, message: "Expects a number")
    return ASTNode::Number.new e.value.to_i64
  rescue ex : SyntaxError
    errors << ex
    ASTNode::Invalid.new
  end

  private def current_token
    @tokens[@index]
  end

  # Matches a token that has string value being included in `token_types`. If a token is successfully found, the @index variable increases 1. Otherwise it will not change
  private def match?(*tokens)
    c = @tokens[@index]
    @index += 1
    if tokens.includes? c.value
      c
    else
      @index -= 1
      nil
    end
  rescue IndexError
    nil
  end

  private def match(*tokens)
    r = self.match? *tokens
    raise SyntaxError.new current_token unless r
    r
  end

  # Gets a token that has token's type being included in `token_types`. If a token is successfully found, the @index variable increases 1. Otherwise it will not change
  private def get?(*token_types)
    c = @tokens[@index]
    @index += 1
    if token_types.includes? c.type
      return c
    else
      @index -= 1
      nil
    end
  rescue IndexError
    nil
  end

  private def get(*token_types, message)
    r = self.get? *token_types
    raise SyntaxError.new current_token unless r
    r
  end
end
