class AddClosingToPointDetailComments < ActiveRecord::Migration[5.0]
  def change
    add_column :point_detail_comments, :closing, :boolean
  end
end
