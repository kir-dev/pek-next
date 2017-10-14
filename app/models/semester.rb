class Semester
  attr_reader :starting_year, :autumn

  # @param [String] semester The semester in the format of '201620171'
  def initialize(semester)
    @starting_year = semester[0, 4].to_i
    @autumn = semester.chars.last == "1"
  end

  def previous
    if autumn
      @starting_year -= 1
    end
    @autumn = !autumn
    return Semester.new(to_s)
  end

  def next
    if !autumn
      @starting_year += 1
    end
    @autumn = !autumn
    return Semester.new(to_s)
  end

  def to_s
    starting_year.to_s + second_year.to_s + (autumn ? 1 : 2).to_s
  end

  def to_readable
    starting_year.to_s + "/" + second_year.to_s + (autumn ? " ősz" : " tavasz")
  end

  private

  def second_year
    starting_year + 1
  end
end
