describe Semester do
  it "Checking autumn semester calculated current in semester's January" do
    Timecop.freeze '2020-01-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be true
    end
  end
  it "Checking autumn semester calculated current in semester's start (September 1st)" do
    Timecop.freeze '2019-09-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be true
    end
  end
  it "Checking autumn semester calculated current in emd of year in semester" do
    Timecop.freeze '2019-12-31' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be true
    end
  end
  it "Checking autumn semester calculated not current  start of next semester (February 1st)" do
    Timecop.freeze '2020-02-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking autumn semester calculated not current in previous year's semester" do
    Timecop.freeze '2019-01-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking autumn semester calculated not current in next year's semester" do
    Timecop.freeze '2021-01-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking autumn semester calculated not current in previous semester (August 31th)" do
    Timecop.freeze '2019-08-31' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking autumn semester calculated not current in next semester's January" do
    Timecop.freeze '2020-02-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be false
    end
  end

  it "Checking spring semester calculated not current in semester's January" do
    Timecop.freeze '2020-01-01' do
      expect(Semester.new("2019202002").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking spring semester calculated current in semester's start (February 1st)" do
    Timecop.freeze '2020-02-01' do
      expect(Semester.new("201920202").to_s==Semester.current.to_s).to be true
    end
  end
  it "Checking spring semester calculated current in emd of semester (August 31st)" do
    Timecop.freeze '2020-08-31' do
      expect(Semester.new("201920202").to_s==Semester.current.to_s).to be true
    end
  end
  it "Checking spring semester calculated not current start of next semester (September 1st)" do
    Timecop.freeze '2020-09-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking spring semester calculated not current in previous years's semester" do
    Timecop.freeze '2019-02-01' do
      expect(Semester.new("201920201").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking autumn semester calculated not current in previous semester (August 31th)" do
    Timecop.freeze '2019-08-31' do
      expect(Semester.new("201920202").to_s==Semester.current.to_s).to be false
    end
  end
  it "Checking autumn semester calculated not current in next semester's January" do
    Timecop.freeze '2021-02-01' do
      expect(Semester.new("201920202").to_s==Semester.current.to_s).to be false
    end
  end
end
