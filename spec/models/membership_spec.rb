# frozen_string_literal: true

describe Membership do
  context 'when user delegated' do
    let(:user)       { create(:user, :who_delegated) }
    let(:membership) { user.primary_membership }
    it 'delegation became false when archive' do
      membership.archive!

      expect(membership.reload.user.delegated).to be false
    end

    it 'delegation became false when inactivate' do
      membership.inactivate!

      expect(membership.reload.user.delegated).to be false
    end
  end

  context 'when newbie' do
    let!(:membership) { create(:membership, :newbie) }
    it 'accepting removes newbie post and sets new member post' do
      membership.accept!
      membership.reload

      expect(membership.newbie?).to be false
      expect(membership.new_member?).to be true
    end

    it 'accepting membership notifies user' do
      expect_any_instance_of(Membership).to receive(:notify).and_call_original

      membership.accept!
      expect(membership.user.notifications.count).to eql(1)
    end
  end

  context 'when member' do
    let!(:membership) { create(:membership) }
    it 'inactivating membership notifies user' do
      expect_any_instance_of(Membership).to receive(:notify).and_call_original

      membership.inactivate!
      expect(membership.user.notifications.count).to eq(1)
    end

    it 'archiving membership notifies user' do
      expect_any_instance_of(Membership).to receive(:notify).and_call_original

      membership.archive!
      expect(membership.user.notifications.count).to eq(1)
    end
  end

  context 'migration to status field' do
    describe 'create' do
      it 'sets status to active' do
        user  = create(:user)
        group = create(:group)

        membership = Membership.create(user: user, group: group)

        expect(membership).to be_status_active
      end
    end

    describe '#inactivate!' do
      it 'sets status to inactive' do
        membership = create(:membership)

        membership.inactivate!
        expect(membership).to be_status_inactive
      end
    end

    describe '#archive!' do
      it 'sets status toarchived' do
        membership = create(:membership)

        membership.archive!
        expect(membership).to be_status_archived
      end
    end
  end
end
