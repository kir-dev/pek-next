module Notifications
  module MembershipNotifier
    extend ActiveSupport::Concern

    LEADER_KEYS = %w[membership.create].freeze
    USER_KEYS   = %w[membership.accept membership.archive membership.inactivate].freeze

    included do
      acts_as_notifiable :users, targets: :targets

      after_update :notify_from_inactivate, if: :end_date_changed?
      after_update :notify_from_archive, if: :archived_changed?
    end

    Membership.prepend(Module.new do
      def accept!(*args)
        super(*args)
        notify_from_accept
      end
    end)

    def targets(key)
      return [group.leader.user] if LEADER_KEYS.include?(key) && group.leader.present?
      return [user] if USER_KEYS.include?(key)

      []
    end

    def notifiable_path(*)
      group_path(group)
    end

    private

    def notify_from_inactivate
      return if end_date.nil?

      notify :users, key: 'membership.inactivate', notifier: group.leader.user
    end

    def notify_from_archive
      return if archived.nil?

      notify :users, key: 'membership.archive', notifier: group.leader.user
    end

    def notify_from_accept
      notify :users, key: 'membership.accept', notifier: group.leader.user
    end
  end
end
