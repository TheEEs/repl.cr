class ASTNode
  def initialize(@left : ASTNode?, @right : ASTNode?)
  end

  def group_by_pathenese
  end

  def eval
    0_i64
  end

  class Invalid < self
    def initialize
      @left = @right = nil
    end
  end

  class Number < self
    def initialize(@v : Int64)
    end

    def eval
      @v
    end

    def value
      @v
    end

    def group_by_pathenese
      @v.to_s
    end
  end

  class Term < self
    def initialize(@left, @right, @sign : String)
    end

    def group_by_pathenese
      "(#{@left.not_nil!.group_by_pathenese}#{@sign}#{@right.not_nil!.group_by_pathenese})"
    end

    def eval
      if @sign == "+"
        @left.not_nil!.eval + @right.not_nil!.eval
      else
        @left.not_nil!.eval - @right.not_nil!.eval
      end
    end
  end

  class Factor < self
    def initialize(@left, @right, @sign : String)
    end

    def group_by_pathenese
      "(#{@left.not_nil!.group_by_pathenese}#{@sign}#{@right.not_nil!.group_by_pathenese})"
    end

    def eval
      if @sign == "*"
        @left.not_nil!.eval * @right.not_nil!.eval
      else
        @left.not_nil!.eval / @right.not_nil!.eval
      end
    end
  end

  class Exponent < self
    def group_by_pathenese
      "(#{@left.not_nil!.group_by_pathenese}**#{@right.not_nil!.group_by_pathenese})"
    end

    def eval
      @left.not_nil!.eval ** @right.not_nil!.eval
    end
  end

  class Unary < self
    def initialize(@sign : String, @right : ASTNode)
    end

    def group_by_pathenese
      "#{@sign}#{@right.not_nil!.group_by_pathenese}"
    end

    def eval
      if @sign == "-"
        return @right.not_nil!.eval
      end
      @right.not_nil!.eval
    end
  end
end
