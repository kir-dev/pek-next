class AddRvtHelperToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rvt_helper, :boolean, default: false
  end
end
