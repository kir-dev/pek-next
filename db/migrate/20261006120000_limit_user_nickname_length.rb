class LimitUserNicknameLength < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL
      UPDATE users
      SET nickname = left(nickname, 30)
      WHERE nickname IS NOT NULL AND char_length(nickname) > 30
    SQL

    change_column :users, :nickname, :string, limit: 30
  end

  def down
    change_column :users, :nickname, :text
  end
end
