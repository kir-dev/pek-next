module Notifications
  module EvaluationNotifier
    extend ActiveSupport::Concern

    class EvaluationNotificationKey
      PREFIX       = "evaluation"
      VALUE_STRINGS = { Evaluation::NOT_YET_ASSESSED => 'not_yet_assessed',
                       Evaluation::REJECTED         => 'rejected',
                       Evaluation::ACCEPTED         => 'accepted' }.freeze

      def initialize(type, value)
        @type  = type
        @value = value
      end

      def group_leader_key?
        [Evaluation::ACCEPTED, Evaluation::REJECTED].include?(@value)
      end

      def resort_leader_key?
        [Evaluation::NOT_YET_ASSESSED].include?(@value)
      end

      def to_s
        [PREFIX, @type, VALUE_STRINGS[@value]].join('.')
      end
    end

    included do
      acts_as_notifiable :users, targets: :targets

      after_update :notify_from_status_change, if: :status_changed?
    end

    def targets(key)
      request_status = key.split('.')[-1]
      return [group.parent.leader.user] if ['not_yet_assessed'].include?(request_status)
      return [group.leader.user] if ['accepted','rejected'].include?(request_status)

      []
    end

    def notifiable_path(*)
      group_evaluation_path(group, self)
    end

    private

    def status_changed?
      point_request_status_changed? || entry_request_status_changed?
    end

    def sender(key)
      return group.parent.leader.user if key.group_leader_key?
      return group.leader.user if key.resort_leader_key?
    end

    def notify_from_status_change
      return unless SystemAttribute.evaluation_season?

      key = EvaluationNotificationKey.new("point_request", point_request_status)
      notify(:users, key: key.to_s , notifier: sender(key)) if point_request_status_changed?

      key = EvaluationNotificationKey.new("entry_request", entry_request_status)
      notify(:users, key: key.to_s, notifier: sender(key)) if entry_request_status_changed?
    end
  end
end
