require 'rails_helper'
RSpec.describe AuditCleanerWorker, type: :worker do
  it 'deletes old versions' do
    with_versioning do
      Timecop.travel '2024-04-19'
      user = create(:user)
      user.update(nickname: 'asd')
      expect(PaperTrail::Version.count).to be > 2

      Timecop.travel '2024-08-19'
      AuditCleanerWorker.new.perform
      expect(PaperTrail::Version.count).to be 0
    end
  end

  it 'keeps versions younger than 3 months' do
    with_versioning do
      Timecop.travel '2024-04-19'
      user = create(:user)
      user.update(nickname: 'asd')
      expect(PaperTrail::Version.count).to be > 2

      Timecop.travel '2024-05-19'
      expect { AuditCleanerWorker.new.perform }.not_to change { PaperTrail::Version.count }
    end
  end
end
