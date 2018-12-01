class Principle < ActiveRecord::Base
  self.primary_key = :id
  self.inheritance_column = nil # So it won't try to interpret the type column as STI

  belongs_to :evaluation
  has_many :point_details

  before_destroy :destroy_associated_point_details

  WORK = 'WORK'.freeze
  RESPONSIBILITY = 'RESPONSIBILITY'.freeze

  validates :name, presence: true
  validates :type, presence: true
  validates :max_per_member, presence: true

  private

  def destroy_associated_point_details
    point_details.destroy_all
  end
end
