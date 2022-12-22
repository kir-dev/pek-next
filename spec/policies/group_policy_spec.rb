describe GroupPolicy, type: :policy do
  subject { described_class }

  permissions :manage_memberships? do
    context 'when the user is the group leader' do
      let(:membership) { create(:membership, :leader) }
      let(:user)       { membership.user }
      let(:group)      { membership.group }

      it 'grants access' do
        expect(subject).to permit(user, group)
      end
    end

    context 'when the user is the group leader assistant' do
      let(:membership) { create(:membership, :leader) }
      let(:user)       { membership.user }
      let(:group)      { membership.group }

      it 'grants access' do
        expect(subject).to permit(user, group)
      end
    end

    context 'when the user is not the group leader' do
      let(:membership) { create(:membership) }
      let(:user)  { membership.user }
      let(:group) { membership.group }

      it 'denies access' do
        expect(subject).not_to permit(user, group)
      end
    end
    context 'when user is not a member' do
      let(:user)  { create(:user) }
      let(:group) { create(:group) }

      it 'denies access' do
        expect(subject).not_to permit(user, group)
      end
    end

    context 'when the user is the evaluation helper at SSSL' do
      before(:each) do
        membership = Membership.create!(user: user, group: group)
        Post.create!(membership: membership, post_type_id: PostType::EVALUATION_HELPER_ID)
      end
      let(:user)  { create(:user) }
      let(:group) { Group.sssl }

      it 'grants access' do
        expect(subject).to permit(user, group)
      end
    end
  end
end
