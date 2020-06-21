# frozen_string_literal: true

class Membership::WithdrawService
  attr_reader :membership

  class MembershipMustHaveDefaultPost < StandardError; end

  def initialize(membership)
    @membership = membership
  end

  def self.call(membership)
    new(membership).perform
  end

  def perform
    raise MembershipMustHaveDefaultPost unless membership.has_post?(PostType::DEFAULT_POST_ID)

    notifications_from_user_to_group = membership.group
                                                 .leader.user
                                                 .notifications.where(
                                                   notifier_id: membership.user.id,
                                                   key:         'membership.create',
                                                   notifiable:  membership)
    membership.destroy!
    notifications_from_user_to_group[0]&.destroy!
  end
end
