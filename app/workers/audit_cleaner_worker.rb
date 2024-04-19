class AuditCleanerWorker
  include Sidekiq::Worker

  def perform(*args)
    # Audit logs can blow up database so we only keep the last three months worth of logs
    PaperTrail::Version.where('created_at < ?', 3.months.ago).delete_all
  end
end
