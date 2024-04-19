# == Schema Information
#
# Table name: principles
#
#  id             :integer          not null, primary key
#  description    :string
#  max_per_member :integer
#  name           :string
#  type           :string
#  evaluation_id  :integer
#  sub_group_id   :bigint
#
# Indexes
#
#  index_principles_on_sub_group_id  (sub_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (evaluation_id => evaluations.id)
#  fk_rails_...  (sub_group_id => sub_groups.id)
#

class Principle < ApplicationRecord
  self.inheritance_column = nil # So it won't try to interpret the type column as STI
  has_paper_trail

  belongs_to :evaluation
  belongs_to :sub_group, optional: true
  has_many :point_details, dependent: :destroy, inverse_of: :principle

  delegate :group, to: :evaluation

  WORK = 'WORK'.freeze
  RESPONSIBILITY = 'RESPONSIBILITY'.freeze

  validates :name, presence: true
  validates :type, presence: true
  validates :max_per_member, presence: true
end
