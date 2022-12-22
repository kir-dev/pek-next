require 'rails_helper'

RSpec.describe SubGroupPolicy, type: :policy do
  subject { described_class.new(user, sub_group) }
  let(:member_actions) { [:index, :show, :join, :leave] }
  let(:leader_actions) { [:create, :new, :update] }
  let(:all_action) { member_actions + leader_actions}

  let(:sub_group) { create(:sub_group) }

  context 'when the user is the group leader' do
    let(:user) { sub_group.group.leader.user }

    it { is_expected.to permit_actions(all_action) }
  end

  context 'when the user is the group leader assistant' do
    let(:user) { sub_group.group.memberships.first(&:leader_assistant?).user }

    it { is_expected.to permit_actions(all_action) }
  end

  context 'when the user is a member' do
    let(:user) { create(:membership, group: sub_group.group).user }

    it { is_expected.to permit_actions(member_actions) }
    it { is_expected.to forbid_actions(leader_actions) }
  end
end
