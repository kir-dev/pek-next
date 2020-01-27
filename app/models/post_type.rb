class PostType < ApplicationRecord
  belongs_to :group, optional: true

  validates :name, presence: true, length: { maximum: 30 }
end
