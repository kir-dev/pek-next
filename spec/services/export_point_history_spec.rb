# frozen_string_literal: true

require 'rails_helper'

describe ExportPointHistory do
  subject(:export) { ExportPointHistory.call(semester.to_s) }
  let!(:membership) { create(:membership, :with_point_request) }
  let!(:group) { membership.group }
  let!(:user) { membership.user }
  let!(:point_request) { user.point_requests.first }
  let!(:evaluation) { point_request.evaluation }
  let!(:semester) { Semester.new(evaluation.semester) }
  let!(:membership_with_zero_point) { create(:membership, :with_point_request) }
  let!(:user_with_zero_point) { membership_with_zero_point.user}

  before do
    point_request.update!(point: 25)
    membership_with_zero_point.update!(group: group)
    user_with_zero_point.reload
    user_with_zero_point.point_requests.first.update!(evaluation: evaluation)
    user_with_zero_point.point_requests.first.update!(point: 0)
    evaluation.update!(point_request_status: Evaluation::ACCEPTED)
    CalculatePointHistory.new(semester).call
  end

  it 'has the correct length' do
    expect(export.length).to eq(2)
  end

  it 'first row has the correct headers' do
    expect(export[0]).to eq(["PéK id", "Név", "Neptun", "BME-id", "Email", "Felvételi pont", "SVIE tagság", "Körök"])
  end

  it 'second row has the correct data' do
    expect(export[1]).to eq([user.id, user.full_name, user.neptun, user.bme_id, user.email, 25,
                             user.svie_member_type, evaluation.group.name])
  end

  it 'user with zero points are not int the export' do
    expect(export.none?{|row| row[0] == user_with_zero_point.id }).to be true
  end
end
