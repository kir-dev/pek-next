# frozen_string_literal: true

require 'rails_helper'

describe ExportActiveUsers do
  subject(:export) { ExportActiveUsers.call(semester.to_s) }
  let(:semester) {"202020211"}
  let(:user) { create(:user, firstname:'Active', lastname: 'User', email: 'active@user.com') }

  before do
    PointHistory.create!(user: user, semester: semester, point: 10)
    SystemAttribute.update_semester(semester)
  end

  it 'has the correct length' do
    expect(export.length).to eq(2)
  end

  it 'first row has the correct headers' do
    expect(export[0]).to eq(["Név","Email"])
  end

  it 'second row has the correct data' do
    expect(export[1]).to eq([user.full_name, user.email])
  end
end
