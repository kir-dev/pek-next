# == Schema Information
#
# Table name: point_histories
#
#  id       :bigint           not null, primary key
#  user_id  :bigint           not null
#  point    :integer          not null
#  semester :string(9)        not null
#

class PointHistory < ApplicationRecord
  belongs_to :user
end
