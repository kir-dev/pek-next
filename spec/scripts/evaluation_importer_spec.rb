# frozen_string_literal: true

require 'rails_helper'
require './scripts/evaluation_importer'

RSpec.describe EvaluationImporter do
  subject(:import) { EvaluationImporter.call(evaluation: evaluation, principles: principles, users: users, points: points, comments: comments) }

  let(:evaluation) { create(:evaluation) }
  let(:leader) { create(:user, firstname: 'Karcsi', lastname: 'Körvez') }
  let(:member) { create(:user, firstname: 'Tibor', lastname: 'Tag') }
  let(:users) { [leader, member].map(&:full_name) }
  let(:principles) do
    [{ name: "Felelősség elv", description: "Felelős munka.", type: "RESPONSIBILITY", max_per_member: 20 },
     { name: "Munka elv", description: "Dolgozni kell.", type: "WORK", max_per_member: 30 }]
  end

  let(:points) do
    [[15, 10], [nil, 20]]
  end

  let(:comments) do
    [['Komment a körveznek', nil], [nil, 'Sokat dologzott']]
  end

  before do
    create(:membership, user: member, group: evaluation.group)
    create(:membership, user: leader, group: evaluation.group)
  end

  it 'creates principles' do
    expect { import }.to change { Principle.count }.by(2)
    principles.each do |principle_attributes|
      expect(Principle.find_by(principle_attributes)).to be_present
    end
  end

  it 'creates point requests' do
    expect { import }.to change { PointRequest.count }.by(2)
  end

  it 'creates points' do
    expect { import }.to change { PointDetail.count }.by(3)
    expect(PointDetail.joins(:point_request, :principle).find_by(point: 15, 'principles.name': 'Felelősség elv', 'point_requests.user_id': leader.id)).to be_present
    expect(PointDetail.joins(:point_request, :principle).find_by(point: 10, 'principles.name': 'Munka elv', 'point_requests.user_id': leader.id)).to be_present
    expect(PointDetail.joins(:point_request, :principle).find_by(point: 20, 'principles.name': 'Munka elv', 'point_requests.user_id': member.id)).to be_present
  end

  it 'creates comments' do
    expect { import }.to change { PointDetailComment.count}.by(2)
    expect(PointDetailComment.joins(point_detail: :point_request).find_by(comment: 'Komment a körveznek', 'point_requests.user_id': leader.id)).to be_present
    expect(PointDetailComment.joins(point_detail: :point_request).find_by(comment: 'Sokat dologzott', 'point_requests.user_id': member.id)).to be_present
  end
end
