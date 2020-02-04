# == Schema Information
#
# Table name: principles
#
#  id             :integer          not null, primary key
#  evaluation_id  :integer
#  name           :string
#  description    :string
#  type           :string
#  max_per_member :integer
#

class Principle < ApplicationRecord
  self.inheritance_column = nil # So it won't try to interpret the type column as STI

  belongs_to :evaluation
  has_many :point_details, dependent: :destroy, inverse_of: :principle

  delegate :group, to: :evaluation

  WORK = 'WORK'.freeze
  RESPONSIBILITY = 'RESPONSIBILITY'.freeze

  validates :name, presence: true
  validates :type, presence: true
  validates :max_per_member, presence: true
end
