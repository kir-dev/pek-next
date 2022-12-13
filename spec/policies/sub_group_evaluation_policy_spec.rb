require 'rails_helper'

RSpec.describe SubGroupEvaluationPolicy, type: :policy do
  subject { described_class.new(user, sub_group) }

  let(:all_action) { [:table, :update_point_request, :update_entry_request] }
  let(:user) { sub_group_membership.membership.user }
  let(:sub_group) { sub_group_membership.sub_group }
  let!(:evaluation) { create(:evaluation, group: sub_group.group, semester: SystemAttribute.semester.to_s) }

  context 'when application season' do
    include_context 'application season'
    context 'when the user is admin of the subgroup' do
      let(:sub_group_membership) { create(:sub_group_membership, admin: true) }

      it { is_expected.to permit_actions(all_action - [:update_entry_request]) }
      it { is_expected.to forbid_actions([:update_entry_request]) }
    end
    context 'when the user is regular subgroup member' do
      let(:sub_group_membership) { create(:sub_group_membership, admin: false) }

      it { is_expected.to forbid_actions(all_action) }
    end
    context 'when the user is a member' do
      let(:sub_group_membership) { create(:sub_group_membership) }
      let(:user) { create(:membership, group: sub_group.group).user }

      it { is_expected.to forbid_actions(all_action) }
    end
    context 'when the user is the group leader' do
      let(:sub_group_membership) { create(:sub_group_membership) }
      let(:user) { sub_group.group.leader.user }

      it { is_expected.to permit_actions(all_action) }
    end
  end
  context 'when off season' do
    include_context 'off season'
    context 'when the user is the group leader' do
      let(:sub_group_membership) { create(:sub_group_membership) }
      let(:user) { sub_group.group.leader.user }

      it { is_expected.to forbid_actions(all_action) }
    end
    context 'when the user is admin of the subgroup' do
      let(:sub_group_membership) { create(:sub_group_membership, admin: true) }

      it { is_expected.to forbid_actions(all_action) }
    end
  end
end

