describe Semester do
  it "autumn_Jan" do
    Timecop.travel Time.zone.parse('2020-01-01')
    expect(Semester.new("2019202001").current?).to be true
  end
  it "autumn_Dec" do
    Timecop.travel Time.zone.parse('2019-12-01')
    expect(Semester.new("2019202001").current?).to be true
  end
  it "spring_true" do
    Timecop.travel Time.zone.parse('2020-03-01')
    expect(Semester.new("2019202002").current?).to be true
  end
  it "spring_false" do
    Timecop.travel Time.zone.parse('2020-12-01')
    expect(Semester.new("2019202001").current?).to be false
  end
  it "wrong_year" do
    Timecop.travel Time.zone.parse('2063-12-01')
    expect(Semester.new("2019202001").current?).to be false
  end
end
