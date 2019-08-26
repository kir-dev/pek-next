class ViewSetting < ApplicationRecord
  enum listing: %i[grid list]

  belongs_to :user
end
