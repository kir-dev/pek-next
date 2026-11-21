require 'rails_helper'

RSpec.describe "SubGroupPrinciples", type: :request do
  let(:group) { Group.sssl }
  let(:sub_group) { create(:sub_group, group: group) }
  let!(:evaluation) { create(:evaluation, group: group) }
  let(:principle) { create(:sub_group_principle, evaluation: evaluation, sub_group: sub_group) }
  let(:user) { group.leader.user }

  before { login_as(user) }

  Group::SUB_GROUP_ENABLED_GROUPS.each do |group_id|
    context "when subgroups are enabled for group #{group_id}" do
      let(:group) { Group.find_by(id: group_id) || create(:group, id: group_id) }

      it 'lists principles' do
        get group_sub_group_principles_path(group, sub_group)

        expect(response).to have_http_status(:ok)
      end

      it 'creates a principle' do
        expect {
          post group_sub_group_principles_path(group, sub_group, format: :js),
               params: { principle: attributes_for(:principle) }
        }.to change { sub_group.principles.count }.by(1)

        expect(response).to have_http_status(:ok)
        expect(sub_group.principles.last.evaluation).to eq(evaluation)
      end

      it 'updates a principle' do
        patch group_sub_group_principle_path(group, sub_group, principle, format: :js),
              params: { principle: { name: 'Updated principle' } }

        expect(response).to have_http_status(:ok)
        expect(principle.reload.name).to eq('Updated principle')
      end

      it 'destroys a principle' do
        principle

        expect {
          delete group_sub_group_principle_path(group, sub_group, principle, format: :js)
        }.to change(Principle, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'when the group is not enabled' do
    let(:group) { create(:group) }

    it 'forbids access' do
      get group_sub_group_principles_path(group, sub_group)

      expect(response).to have_http_status(:forbidden)
    end

    it 'forbids creating a principle' do
      expect {
        post group_sub_group_principles_path(group, sub_group, format: :js),
             params: { principle: attributes_for(:principle) }
      }.not_to change(Principle, :count)

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when the user is a regular group member' do
    let(:user) { create(:membership, group: group).user }

    it 'forbids access' do
      get group_sub_group_principles_path(group, sub_group)

      expect(response).to have_http_status(:forbidden)
    end
  end

  it 'rejects a subgroup belonging to another enabled group' do
    other_group = create(:group, id: Group::SZITA_ID)
    other_sub_group = create(:sub_group, group: other_group)

    expect {
      get group_sub_group_principles_path(group, other_sub_group)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'rejects updating a principle belonging to another subgroup' do
    other_sub_group = create(:sub_group, group: group)
    other_principle = create(:sub_group_principle, evaluation: evaluation, sub_group: other_sub_group)

    expect {
      patch group_sub_group_principle_path(group, sub_group, other_principle, format: :js),
            params: { principle: { name: 'Wrong subgroup' } }
    }.to raise_error(ActiveRecord::RecordNotFound)

    expect(other_principle.reload.name).not_to eq('Wrong subgroup')
  end

  it 'rejects deleting a principle belonging to another subgroup' do
    other_sub_group = create(:sub_group, group: group)
    other_principle = create(:sub_group_principle, evaluation: evaluation, sub_group: other_sub_group)

    expect {
      delete group_sub_group_principle_path(group, sub_group, other_principle, format: :js)
    }.to raise_error(ActiveRecord::RecordNotFound)

    expect(Principle.exists?(other_principle.id)).to eq(true)
  end

  it 'forbids updating a principle from a previous evaluation' do
    previous_evaluation = create(:evaluation, group: group, semester: SystemAttribute.semester.previous.to_s)
    previous_principle = create(:sub_group_principle, evaluation: previous_evaluation, sub_group: sub_group)

    patch group_sub_group_principle_path(group, sub_group, previous_principle, format: :js),
          params: { principle: { name: 'Wrong evaluation' } }

    expect(response).to have_http_status(:forbidden)
    expect(previous_principle.reload.name).not_to eq('Wrong evaluation')
  end
end
