require 'rails_helper'

RSpec.describe SubGroupPrinciplePolicy, type: :policy do
  subject { described_class.new(user, sub_group_principle) }

  let(:all_action) { [:index, :create, :update, :destroy] }

  let(:sub_group_principle) { create(:sub_group_principle) }
  let(:group) { sub_group_principle.sub_group.group }
  context 'when the user is the group leader' do
    let(:user) { group.leader.user }

    it { is_expected.to permit_actions(all_action) }
  end

  context 'when the user is the group leader assistant' do
    let(:user) { group.memberships.first(&:leader_assistant?).user }

    it { is_expected.to permit_actions(all_action) }
  end

  context 'when the user is the sub group admin' do
    let(:user) { create(:sub_group_membership,
                        sub_group: sub_group_principle.sub_group,
                        admin: true).membership.user }

    it { is_expected.to permit_actions(all_action) }
  end

  context 'when the user is a member' do
    let(:user) { create(:membership, group: group).user }

    it { is_expected.to forbid_actions(all_action) }
  end
end

