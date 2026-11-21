require 'rails_helper'

RSpec.describe "SubGroupEvaluations", type: :request do
  include_context 'application season'

  let(:group) { Group.sssl }
  let(:sub_group) { create(:sub_group, group: group) }
  let!(:evaluation) { create(:evaluation, group: group) }
  let(:user) { group.leader.user }

  before { login_as(user) }

  Group::SUB_GROUP_ENABLED_GROUPS.each do |group_id|
    context "when subgroups are enabled for group #{group_id}" do
      let(:group) { Group.find_by(id: group_id) || create(:group, id: group_id) }

      it 'shows the evaluation table' do
        get group_sub_group_evaluation_table_path(group, sub_group, evaluation)

        expect(response).to have_http_status(:ok)
        expect(response).to render_template('evaluations/table')
      end
    end
  end

  context 'when the group is not enabled' do
    let(:group) { create(:group) }

    it 'forbids access' do
      get group_sub_group_evaluation_table_path(group, sub_group, evaluation)

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when the user is a regular group member' do
    let(:user) { create(:membership, group: group).user }

    it 'forbids access' do
      get group_sub_group_evaluation_table_path(group, sub_group, evaluation)

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when it is off season' do
    include_context 'off season'

    it 'forbids access even for the group leader' do
      get group_sub_group_evaluation_table_path(group, sub_group, evaluation)

      expect(response).to have_http_status(:forbidden)
    end
  end

  it 'rejects a subgroup belonging to another enabled group' do
    other_group = create(:group, id: Group::SZITA_ID)
    other_sub_group = create(:sub_group, group: other_group)

    expect {
      get group_sub_group_evaluation_table_path(group, other_sub_group, evaluation)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'rejects an evaluation belonging to another enabled group' do
    other_group = create(:group, id: Group::SZITA_ID)
    other_evaluation = create(:evaluation, group: other_group)

    expect {
      get group_sub_group_evaluation_table_path(group, sub_group, other_evaluation)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
