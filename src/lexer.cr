require "./token"

class Lexer
  DIGITS    = ('0'..'9').to_a
  OPERATORS = {'+', '-', '*', '/'}
  PATHENS   = {'(', ')'}
  SKIP      = {' '}
  END       = {'\n', ';'}

  getter errors = [] of SyntaxError

  @line = 1
  @column = 0

  def initialize(@source_code : String)
    @i = 0
    @tokens = [] of Token
  end

  def clear
    @tokens.clear
  end

  def consume
    while @i < @source_code.size
      c = @source_code[@i]
      if DIGITS.includes? c
        @tokens << scan_digit
      elsif OPERATORS.includes? c
        @tokens << scan_operator
      elsif PATHENS.includes? c
        @tokens << scan_pathen
      elsif SKIP.includes? c
        next scan_skip
      elsif END.includes? c
        @tokens << scan_end_of_line
      else
        self.error_handle
      end
    end
    if @tokens.last? && !@tokens.last.type.end?
      @tokens << Token.new ";", TokenType::END
    end
    @tokens
  end

  private def error_handle
    @i += 1
    @column += 1
    c = @column
    t = Token.new("#{previous_char}", TokenType::FAULT)
    t.line, t.column = @line, c
    errors << SyntaxError.new t
  end

  private def current_char
    @source_code[@i]
  end

  private def next_char
    @source_code[@i += 1]
  end

  private def previous_char
    @source_code[@i - 1]
  end

  private def scan_skip
    @i += 1
    @column += 1
  end

  private def scan_end_of_line
    if current_char == '\n'
      @column = 0
      @line += 1
    end
    Token.new (@i += 1; "#{previous_char}"), TokenType::END
  end

  private def scan_digit
    c = @column + 1
    str = ""
    while DIGITS.includes? @source_code[@i]?
      str += @source_code[@i]
      @i += 1
      @column += 1
    end
    t = Token.new str, TokenType::NUMBER
    t.line = @line
    t.column = c
    t
  end

  private def scan_operator
    c = @column + 1
    str = current_char
    if next_char == '*'
      str += "*"
      @i += 1
      @column += 1
    end
    t = Token.new str.to_s, TokenType::OPERATOR
    t.line, t.column = @line, c
    t
  end

  private def scan_pathen
    c = @column + 1
    str = current_char.to_s
    @i += 1
    @column += 1
    t = Token.new str, TokenType::PATHEN
    t.line, t.column = @line, c
    t
  end
end
