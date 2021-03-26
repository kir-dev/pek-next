# frozen_string_literal: true

describe Membership::WithdrawService do
  context 'when the membersip has DEFAULT_POST' do
    let(:membership) { create(:membership, :newbie) }
    it 'destroys the membership' do
      expect do
        described_class.call(membership)
      end.to change { membership.group.memberships.count }.by -1
    end

    it 'removes the notification' do
      membership.notify(:users, key: 'membership.create', notifier: membership.user)

      expect do
        described_class.call(membership)
      end.to change { membership.group.leader.user.notifications.count }.by -1
    end

    context 'when the user has PointRequests' do
      let(:membership) { create(:membership, :with_point_request, :newbie) }

      it "raises MembershipHasPointRequests" do
        expect { described_class.call(membership) }.to raise_error(Membership::WithdrawService::MembershipHasPointRequests)
      end
    end
  end

  context 'when the membership has no DEFAULT_POST' do
    it 'raises MembershipMustHaveDefaultPost' do
      membership = create(:membership)

      expect do
        described_class.call(membership)
      end.to raise_error(Membership::WithdrawService::MembershipMustHaveDefaultPost)
    end
  end
end
