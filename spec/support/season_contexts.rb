module SeasonHelpers
  shared_context "off season" do
    before(:each) do
      SystemAttribute.update_season(SystemAttribute::OFFSEASON)
    end
  end

  shared_context "application season" do
    before(:each) do
      SystemAttribute.update_season(SystemAttribute::APPLICATION_SEASON)
    end
  end

  shared_context "evaluation season" do
    before(:each) do
      SystemAttribute.update_season(SystemAttribute::EVALUATION_SEASON)
    end
  end
end
