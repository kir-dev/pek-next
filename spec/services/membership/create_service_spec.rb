# frozen_string_literal: true

describe Membership::CreateService do
  context 'when the user has an archived membership' do
    it 'removes archivation and gives back the default post' do
      membership = create(:membership, :archived)

      expect do
        described_class.call(membership.group, membership.user)
      end.to change { membership.group.leader.user.notifications.count }.by 1

      membership.reload
      expect(membership).not_to be_archived
      expect(membership).to be_newbie
    end
  end

  context 'when the user has an active membership' do
    it 'raises AlreadyMember' do
      membership = create(:membership)

      expect do
        described_class.call(membership.group, membership.user)
      end.to raise_error(Membership::CreateService::AlreadyMember)
    end
  end

  context 'when the user has an inactive membership' do
    it 'raises AlreadyMember' do
      membership = create(:membership, end_date: Date.today)

      expect do
        described_class.call(membership.group, membership.user)
      end.to raise_error(Membership::CreateService::AlreadyMember)
    end
  end

  context 'when the group does not receive new members' do
    it 'raises GroupNotReceivingNewMembers' do
      group = create(:group, users_can_apply: false)
      user  = create(:user)

      expect do
        described_class.call(group, user)
      end.to raise_error(Membership::CreateService::GroupNotReceivingNewMembers)
    end
  end

  it 'creates a membership' do
    group = create(:group)
    user  = create(:user)

    expect do
      described_class.call(group, user)
    end.to change { Membership.count }.by 1

    membership = Membership.last
    expect(membership).to be_newbie
    expect(membership.group).to eq(group)
    expect(membership.user).to eq(user)
  end
end
