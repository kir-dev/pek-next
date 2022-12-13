require 'rails_helper'

RSpec.describe PointDetailPolicy, type: :policy do
  subject { described_class.new(user, evaluation, principle) }
  let(:all_action){ [:update_point_request, :update_comments]}
  let(:sub_group_principle) { create(:sub_group_principle,sub_group: sub_group) }
  let(:principle) { sub_group_principle }
  let(:user) { sub_group_membership.membership.user }
  let(:sub_group) { sub_group_membership.sub_group }
  let!(:evaluation) { create(:evaluation, group: sub_group.group, semester: SystemAttribute.semester.to_s) }

  context 'when application season' do
    include_context 'application season'

    context 'when the user is a sub group admin' do
      let(:sub_group_membership) { create(:sub_group_membership, admin: true) }

      it { is_expected.to permit_actions(all_action)}
    end

    context 'when the user is a sub group member' do
      let(:sub_group_membership) { create(:sub_group_membership) }

      it { is_expected.to forbid_actions(all_action)}
    end
  end
end
