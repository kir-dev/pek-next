describe JudgementPolicy, type: :policy do
  let(:evaluation) { create(:evaluation) }

  subject { described_class.new(user, evaluation) }

  context "when evaluation season" do
    include_context "evaluation season"

    context 'and RVT member' do
      let(:user) { create(:membership, :for_rvt_group).user }
      it { is_expected.to permit_actions(%i[show index]) }
      it { is_expected.to forbid_actions(%i[update accept update_point_request_status update_entry_request_status]) }
    end

    context "and leader of the resort" do
      let(:user) { evaluation.group.parent.leader.user }

      it { is_expected.to forbid_action(:accept) }
      it { is_expected.to permit_actions(%i[update_point_request_status update_entry_request_status]) }

      context 'and the point request is accepted' do
        before(:each) do
          evaluation.update(point_request_status: Evaluation::ACCEPTED)
        end

        it { is_expected.to forbid_action(:update_point_request_status) }
        it { is_expected.to permit_actions(%i[update_entry_request_status update]) }
      end

      context 'and the entry request is accepted' do
        before(:each) do
          evaluation.update(entry_request_status: Evaluation::ACCEPTED)
        end

        it { is_expected.to forbid_action(:update_entry_request_status) }
        it { is_expected.to permit_actions(%i[update_point_request_status update]) }
      end
    end

    context "and leader of RVT" do
      let(:user) { Group.find(Group::RVT_ID).leader.user }

      it { is_expected.to permit_actions(%i[accept update update_point_request_status update_entry_request_status]) }

      context "and bot request are accepted" do
        before(:each) do
          evaluation.update(point_request_status: Evaluation::ACCEPTED)
          evaluation.update(entry_request_status: Evaluation::ACCEPTED)
        end

        it { is_expected.to permit_actions(%i[accept update update_point_request_status update_entry_request_status]) }
      end
    end
  end
end
