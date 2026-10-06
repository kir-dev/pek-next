class LimitUserNicknameLength < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL
      UPDATE users
      SET nickname = left(nickname, 30)
      WHERE nickname IS NOT NULL AND char_length(nickname) > 30
    SQL

    execute <<~SQL
      UPDATE users
      SET firstname = left(firstname, 30)
      WHERE char_length(firstname) > 30
    SQL

    execute <<~SQL
      UPDATE users
      SET lastname = left(lastname, 30)
      WHERE char_length(lastname) > 30
    SQL

    change_column :users, :nickname, :string, limit: 30
    change_column :users, :firstname, :string, limit: 30
    change_column :users, :lastname, :string, limit: 30
  end

  def down
    change_column :users, :nickname, :text
    change_column :users, :firstname, :text
    change_column :users, :lastname, :text
  end
end
