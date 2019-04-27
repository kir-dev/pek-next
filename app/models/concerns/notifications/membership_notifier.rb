module Notifications
  module MembershipNotifier
    extend ActiveSupport::Concern

    LEADER_KEYS = %w[membership.create].freeze
    USER_KEYS   = %w[].freeze

    included do
      acts_as_notifiable :users, targets: :targets
      after_create :notify_leader_from_create
    end

    def notify_leader_from_create
      notify :users, key: 'membership.create', notifier: user
    end

    def targets(key)
      return [group.leader.user] if LEADER_KEYS.include?(key)
      return [membership.user] if USER_KEYS.include?(key)

      []
    end

    def notifiable_path(*)
      group_path(group)
    end
  end
end
