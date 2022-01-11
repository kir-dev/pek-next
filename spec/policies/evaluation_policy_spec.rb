RSpec.describe EvaluationPolicy, type: :policy do
  subject { described_class.new(user, evaluation) }

  let(:evaluation)              { create(:evaluation) }
  let(:evaluation_actions)      { %i[show current table edit update edit_justification] }
  let(:evaluation_view_actions) { evaluation_actions - %i[edit update edit_justification] }
  let(:point_request_actions)   { %i[submit_point_request cancel_point_request update_point_request] }
  let(:entry_request_actions)   { %i[submit_entry_request cancel_entry_request update_entry_request] }
  let(:submit_actions)          { %i[submit_point_request submit_entry_request] }
  let(:cancel_actions)          { %i[cancel_point_request cancel_entry_request] }
  let(:update_request_actions)  { %i[update_point_request update_entry_request] }
  let(:update_comment_actions)  { %i[update_comments] + evaluation_view_actions }
  let(:all_action)              { entry_request_actions + point_request_actions + evaluation_actions }

  context 'when application season' do
    include_context 'application season'

    context 'and the user is the group leader' do
      let(:user) { evaluation.group.leader.user }

      it { is_expected.to permit_actions(all_action - cancel_actions) }
      it { is_expected.to permit_actions(update_comment_actions) }
      it { is_expected.to forbid_actions(cancel_actions) }

      context "and the request is submitted" do
        before(:each) do
          evaluation.point_request_status = Evaluation::NOT_YET_ASSESSED
          evaluation.entry_request_status = Evaluation::NOT_YET_ASSESSED
        end

        it { is_expected.to permit_actions(cancel_actions) }
        it { is_expected.to forbid_actions(submit_actions) }

        it { is_expected.to permit_actions(evaluation_view_actions) }
        it { is_expected.to forbid_actions(update_request_actions) }
      end
    end

    context "and the user is the evaluation helper of the group" do
      let(:user) do
        evaluation.group.memberships.select(&:evaluation_helper?).first.user
      end

      it { is_expected.to permit_actions(evaluation_view_actions + update_request_actions + [:edit_justification] ) }
      it { is_expected.to forbid_actions(all_action - evaluation_view_actions - update_request_actions - [:edit_justification])  }
    end

    context 'and the user is a leader of another the group' do
      let(:user) { create(:group).leader.user }

      it { is_expected.to forbid_actions(all_action) }
    end

    context 'and the user is a leader of another group in the resort' do
      let(:user) { evaluation.group.parent.children.select{ |g| g != evaluation.group }.first.leader.user }

      it { is_expected.to  permit_actions(evaluation_view_actions) }
      it { is_expected.to  forbid_actions(all_action - evaluation_view_actions) }
    end

    context 'and the group has no parents' do
      let(:user) { create(:user) }

      before(:each) do
        evaluation.group.update(parent: nil)
      end

      it { is_expected.to forbid_actions(all_action) }
    end

    context 'and the user is the leader of the group resort' do
      let(:user) { evaluation.group.parent.leader.user }

      it { is_expected.to permit_actions(evaluation_view_actions) }
      it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
    end

    context 'and the user is the leader of the parent group, but the group is not a resort' do
      let(:user) { evaluation.group.parent.leader.user }
      before(:each) do
        evaluation.group.parent.update(parent_id: create(:group).id)
      end

      it { is_expected.to forbid_actions(all_action) }
    end

    context 'and the user is the leader of the RVT' do
      let(:user) { Group.rvt.leader.user }

      it { is_expected.to permit_actions(evaluation_view_actions) }
      it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
    end

    context 'and the user is an evaluation helper in the group resort' do
      let(:user) do
        evaluation.group.parent.children.reject do |group|
          group == evaluation.group
        end.first.leader.user
      end

      it { is_expected.to permit_actions(evaluation_view_actions) }
      it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
    end

    context 'when the user is evaluation helper at resort?' do
      let(:user) do
        evaluation.group.parent.memberships.select(&:evaluation_helper?).first.user
      end

      it { is_expected.to permit_action(:show) }
    end

    context 'when the user is a leader in the resort' do
      let(:user) do
        evaluation.group.leader.user
      end

      let(:resort_evaluation) do
        new_evaluation = Evaluation.new.set_default_values
        new_evaluation.group = evaluation.group.parent
        new_evaluation.semester = SystemAttribute.semester.to_s
        new_evaluation.save!
        new_evaluation
      end

      it { expect(EvaluationPolicy.new(user, resort_evaluation)).to permit_action(:show) }
    end
  end

  context 'when evaluation season' do
    include_context 'evaluation season'

    context "and the user is the group leader" do
      let(:user) { evaluation.group.leader.user }

      context "and the evaluation is not yet assessed" do
        before(:each) do
          evaluation.point_request_status = Evaluation::NOT_YET_ASSESSED
          evaluation.entry_request_status = Evaluation::NOT_YET_ASSESSED
        end

        it { is_expected.to permit_actions(evaluation_view_actions) }
        it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
      end

      context "and the point request is rejected" do
        before { evaluation.point_request_status = Evaluation::REJECTED }

        it { is_expected.to permit_actions(point_request_actions - cancel_actions) }
      end

      context "when the entry_request is rejected" do
        before { evaluation.entry_request_status = Evaluation::REJECTED }

        it { is_expected.to permit_actions(entry_request_actions - cancel_actions) }
      end
    end

    context "when the user is the resort leader" do
      let(:user) { evaluation.group.parent.leader.user }

      it { is_expected.to permit_actions(update_request_actions + evaluation_view_actions + [:edit_justification]) }
      it { is_expected.to forbid_actions(all_action - (update_request_actions + evaluation_view_actions) - [:edit_justification]) }

      context "and the point and entry request is accepted" do
        before do
          evaluation.point_request_status = Evaluation::ACCEPTED
          evaluation.entry_request_status = Evaluation::ACCEPTED
        end

        it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
      end
    end

    context "when the user is the leader of RVT" do
      let(:user) { Group.rvt.leader.user }

      it { is_expected.to permit_actions(update_request_actions + evaluation_view_actions + [:edit_justification]) }
      it { is_expected.to forbid_actions(all_action - (update_request_actions + evaluation_view_actions) - [:edit_justification]) }

      context "and the point and entry request is accepted" do
        before do
          evaluation.point_request_status = Evaluation::ACCEPTED
          evaluation.entry_request_status = Evaluation::ACCEPTED
        end

        it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
      end
    end
  end

  context 'off season' do
    include_context 'off season'
    let(:user) { evaluation.group.leader.user }

    it { is_expected.to forbid_actions(all_action) }
  end
end
