require 'rails_helper'

RSpec.describe JudgementPolicy, type: :policy do
  let(:evaluation) { create(:evaluation) }

  subject { described_class.new(user, evaluation) }

  context "when evaluation season" do
    include_context "evaluation season"

    context "and leader of the resort" do
      let(:user) { evaluation.group.parent.leader.user}

      it { is_expected.to forbid_action(:accept) }
      it { is_expected.to permit_action(:reject) }
    end

    context "and leader of RVT" do
      let(:user) { Group.find(Group::RVT_ID).leader.user }

      it { is_expected.to permit_actions([:accept, :reject]) }
    end
  end
end
