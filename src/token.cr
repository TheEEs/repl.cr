enum TokenType
  # literals
  NUMBER
  STRING

  # operators
  OPERATOR

  PATHEN

  # SPECIALS
  FAULT
  END
end

struct Token
  property column = 0
  property line = 0

  def initialize(@value : String, @token_type : TokenType)
  end

  def value : String
    @value
  end

  def type
    @token_type
  end

  macro method_missing(call)
  def {{call.id}}
    @token_type.{{call}}
  end
  end
end
