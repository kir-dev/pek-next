# == Schema Information
#
# Table name: im_accounts
#
#  id       :bigint           not null, primary key
#  protocol :string(50)       not null
#  name     :string(255)      not null
#  user_id  :bigint
#

class ImAccount < ApplicationRecord
  belongs_to :user
end
