module Notifications
  module EvaluationNotifier
    extend ActiveSupport::Concern

    RESORT_LEADER_KEYS = ['evaluation.not_yet_assessed'].freeze
    GROUP_LEADER_KEYS  = ['evaluation.rejected', 'evaluation.accepted'].freeze
    ALL_KEYS           = { Evaluation::NOT_YET_ASSESSED => 'evaluation.not_yet_assessed',
                           Evaluation::REJECTED         => 'evaluation.rejected',
                           Evaluation::ACCEPTED         => 'evaluation.accepted' }.freeze

    included do
      acts_as_notifiable :users, targets: :targets

      after_update :notify_from_status_change, if: :status_changed?
    end

    # Membership.prepend(Module.new do
    #   def accept!(*args)
    #     super(*args)
    #     notify_from_accept
    #   end
    # end)

    def targets(key)
      return [group.parent.leader.user] if resort_leader_key?(key)
      return [group.leader.user] if group_leader_key?(key)

      []
    end

    def notifiable_path(*)
      group_evaluation_path(group, self)
    end

    private

    def group_leader_key?(key)
      GROUP_LEADER_KEYS.include?(key)
    end

    def resort_leader_key?(key)
      RESORT_LEADER_KEYS.include?(key)
    end

    def status_changed?
      point_request_status_changed? || entry_request_status_changed?
    end

    def sender(key)
      return group.parent.leader.user if group_leader_key?(key)
      return group.leader.user if resort_leader_key?(key)
    end

    def notify_from_status_change
      key = ALL_KEYS[point_request_status]
      notify(:users, key: key, notifier: sender(key)) if point_request_status_changed?

      key = ALL_KEYS[entry_request_status]
      notify(:users, key: key, notifier: sender(key)) if entry_request_status_changed?
    end
  end
end
