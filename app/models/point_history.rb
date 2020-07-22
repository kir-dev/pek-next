# == Schema Information
#
# Table name: point_histories
#
#  id       :bigint           not null, primary key
#  point    :integer          not null
#  semester :string(9)        not null
#  user_id  :bigint           not null
#
# Indexes
#
#  index_point_histories_on_user_id_and_semester  (user_id,semester) UNIQUE
#
# Foreign Keys
#
#  point_history_usr_id_fkey  (user_id => users.id)
#

class PointHistory < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: { scope: :semester }
end
