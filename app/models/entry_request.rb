# == Schema Information
#
# Table name: entry_requests
#
#  id            :bigint           not null, primary key
#  entry_type    :string(255)
#  justification :text
#  evaluation_id :bigint           not null
#  user_id       :bigint
#

class EntryRequest < ApplicationRecord
  belongs_to :evaluation
  belongs_to :user

  AB = 'AB'.freeze
  KB = 'KB'.freeze
  KDO = 'KDO'.freeze
  DEFAULT_TYPE = KDO

  after_save do
    evaluation.update_last_change!
  end

  def self.remove_justifications
    where(entry_type: KDO).update_all(justification: '')
  end

  def accepted?
    evaluation.entry_request_accepted?
  end
end
