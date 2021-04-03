describe MembershipPolicy, type: :policy do
  subject { described_class }

  permissions :archive?, :unarchive?, :inactivate?, :reactivate?, :accept? do
    context 'when the user is a group member' do
      let(:membership) { create(:membership, :newbie) }
      let(:group) { membership.group }

      context 'and the current user is the group leader' do
        let(:user) { group.leader.user }

        it 'permits the actions' do
          expect(subject).to permit(user, membership)
        end
      end

      context 'when the current user owns the membership' do
        let(:user) { membership.user }

        it 'is forbidden' do
          expect(subject).not_to permit(user, membership)
        end
      end

      context 'and the current user is not a member' do
        let(:user) { create(:user) }

        it 'is forbidden' do
          expect(subject).not_to permit(user, membership)
        end
      end
    end
  end

  permissions :withdraw? do
    context 'when the memberhsip belong to the user' do
      let(:membership) { create(:membership) }
      let(:user)       { membership.user }

      it 'permits the action' do
        expect(subject).to permit(user, membership)
      end
    end
  end
end
