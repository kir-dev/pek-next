RSpec.describe ApplicationPolicy, type: :policy do
  subject { described_class.new(user, nil) }

  describe 'manage_SVIE?' do
    context 'when the user is the RVT leader' do
      let(:user) { Group.rvt.leader.user }

      it { is_expected.to permit_actions([:manage_SVIE]) }
    end
  end
end
