class ChangeIdToAutoIncrementEverywhere < ActiveRecord::Migration
  def change
    sql = <<-SQL.squish
      CREATE SEQUENCE belepoigenyles_id_seq;
      ALTER TABLE belepoigenyles ALTER id SET DEFAULT nextval('belepoigenyles_id_seq');

      CREATE SEQUENCE pontigenyles_id_seq;
      ALTER TABLE pontigenyles ALTER id SET DEFAULT nextval('pontigenyles_id_seq');

      CREATE SEQUENCE ertekeles_uzenet_id_seq;
      ALTER TABLE ertekeles_uzenet ALTER id SET DEFAULT nextval('ertekeles_uzenet_id_seq');
    SQL
    Evaluation.connection.execute(sql)
  end
end
