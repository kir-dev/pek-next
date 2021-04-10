class Semester
  attr_reader :starting_year, :autumn

  # @param [String] semester The semester in the format of '201620171'
  def initialize(semester)
    @starting_year = semester[0, 4].to_i
    @autumn = semester.chars.last == '1'
  end

  def self.from_year(year, autumn)
    Semester.new(year + (autumn ? '1' : '2'))
  end
  def self.current
    if (1..8).include? Time.current.month
      if Time.current.month ==1
        return Semester.new((Time.current.year-1).to_s  + '1')
      else
        return Semester.new((Time.current.year-1).to_s + '2')
      end
    else
      return Semester.new((Time.current.year).to_s  + '1')
    end
  end

  def previous
    Semester.new(to_s).previous!
  end

  def previous!
    @starting_year -= 1 if autumn
    @autumn = !autumn
    self
  end

  def next
    Semester.new(to_s).next!
  end

  def next!
    @starting_year += 1 unless autumn
    @autumn = !autumn
    self
  end

  def to_s
    "#{starting_year}#{second_year}#{autumn ? 1 : 2}"
  end

  def to_readable
    "#{starting_year}/#{second_year} #{autumn ? 'ősz' : 'tavasz'}"
  end

  def save
    SystemAttribute.update_semester(to_s)
  end

  private

  def second_year
    starting_year + 1
  end
end
