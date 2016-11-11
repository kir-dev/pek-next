class Semester
  attr_accessor :val

  def initialize(semester)
    @val = semester.to_i
  end

  def previous
    if @val % 2 == 0
      @val = @val - 1
    else
      @val = @val - 100009
    end
    return self
  end

  def next
    if @val % 2 == 1
      @val = @val + 1
    else
      @val = @val + 100009
    end
    return self
  end

  def to_s
    @val.to_s
  end
end
