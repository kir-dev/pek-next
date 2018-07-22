class ViewSetting < ActiveRecord::Base
  enum listing: %i[grid list]

  belongs_to :user
end
