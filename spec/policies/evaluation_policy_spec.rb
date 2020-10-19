RSpec.describe EvaluationPolicy, type: :policy do
  subject { described_class.new(user, evaluation) }

  let(:evaluation) { create(:evaluation) }
  let(:evaluation_actions)      { %i[show current table edit update] }
  let(:evaluation_view_actions) { evaluation_actions - %i[edit update] }
  let(:point_request_actions)   { %i[submit_point_request cancel_point_request] }
  let(:entry_request_actions)   { %i[submit_entry_request cancel_entry_request] }
  let(:cancel_actions)          { %i[cancel_point_request cancel_entry_request] }
  let(:all_action)              { entry_request_actions + point_request_actions + entry_request_actions }

  context 'when application season' do
    include_context 'application season'

    context 'leader of the group' do
      let(:user) { evaluation.group.leader.user }

      it { is_expected.to permit_actions(all_action - cancel_actions) }
    end

    context 'leader of another the group' do
      let(:user) { create(:group).leader.user }

      it { is_expected.to forbid_actions(all_action) }
    end

    context 'leader of the group resort' do
      let(:user) { evaluation.group.parent.leader.user }

      it { is_expected.to permit_actions(evaluation_view_actions) }
      it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
    end
  end

  context 'evaluation season' do
    include_context 'evaluation season'
    let(:user) { evaluation.group.leader.user }

    it { is_expected.to permit_actions(evaluation_view_actions) }
    it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }

    context "when the point request is rejected" do
      before { evaluation.point_request_status = Evaluation::REJECTED }

      it { is_expected.to permit_actions(point_request_actions - cancel_actions ) }
    end

    context "whetn the entry_request is rejected" do
      before { evaluation.entry_request_status = Evaluation::REJECTED }

      it { is_expected.to permit_actions(entry_request_actions - cancel_actions) }
    end
  end

  context 'off season' do
    include_context 'off season'
    let(:user) { evaluation.group.leader.user }

    it { is_expected.to forbid_actions(all_action) }
  end
end
