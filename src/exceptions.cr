class SyntaxError < Exception
  getter token : Token

  def initialize(@token : Token)
  end

  def initialize(@message : String, @token : Token)
  end
end
