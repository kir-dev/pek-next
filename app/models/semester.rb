class Semester
  attr_reader :starting_year, :autumn

  # @param [String] semester The semester in the format of '201620171'
  def initialize(semester)
    @starting_year = semester[0, 4].to_i
    @autumn = semester.chars.last == "1"
  end

  def previous
    if @autumn
      @starting_year -= 1
    else
    @autumn = !@autumn
    return self
  end

  def next
    if !@autumn
      @starting_year += 1
    else
    @autumn = !@autumn
    return self
  end

  def to_s
    @starting_year.to_s + (@starting_year + 1).to_s + (@autumn ? 1 : 0).to_s
  end
end
