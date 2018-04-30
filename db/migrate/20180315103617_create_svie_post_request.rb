class CreateSviePostRequest < ActiveRecord::Migration
  def up
    create_table :svie_post_requests do |t|
      t.string :member_type
      t.integer :usr_id
    end

    change_svie_member_type 'RENDESTAG', 'BELSOSTAG'
    change_svie_member_type 'PARTOLOTAG', 'KULSOSTAG'

    User.where(usr_svie_state: 'FELDOLGOZASALATT').each do |user|
      SviePostRequest.create(user: user, member_type: user.usr_svie_member_type)
      user.update(usr_svie_member_type: 'NEMTAG')
    end
    remove_column :users, :usr_svie_state
  end

  def down
    add_column :users, :usr_svie_state, :string

    SviePostRequest.all.each do |post_request|
      post_request.user.update(usr_svie_member_type: post_request.member_type, usr_svie_state: 'FELDOLGOZASALATT' )
    end

    change_svie_member_type 'BELSOSTAG', 'RENDESTAG'
    change_svie_member_type 'KULSOSTAG', 'PARTOLOTAG'

    drop_table :svie_post_requests
  end

  private

  def change_svie_member_type(from, to)
    User.where(usr_svie_member_type: from).update_all(usr_svie_member_type: to)
  end
end
