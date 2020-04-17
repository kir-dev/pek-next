# == Schema Information
#
# Table name: im_accounts
#
#  id       :bigint           not null, primary key
#  name     :string(255)      not null
#  protocol :string(50)       not null
#  user_id  :bigint
#
# Foreign Keys
#
#  im_accounts_usr_id_fkey  (user_id => users.id)
#

class ImAccount < ApplicationRecord
  belongs_to :user
end
