class CreateSviePostRequest < ActiveRecord::Migration
  def change
    create_table :svie_post_requests do |t|
      t.string :member_type
      t.integer :usr_id
    end
  end
end
