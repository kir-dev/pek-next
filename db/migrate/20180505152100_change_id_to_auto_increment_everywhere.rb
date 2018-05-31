class ChangeIdToAutoIncrementEverywhere < ActiveRecord::Migration

  def up
    sql = <<-SQL.squish
      CREATE SEQUENCE belepoigenyles_id_seq;
      ALTER TABLE belepoigenyles ALTER id SET DEFAULT nextval('belepoigenyles_id_seq');
      SELECT setval('belepoigenyles_id_seq', COALESCE((SELECT MAX(id) FROM belepoigenyles), 1));

      CREATE SEQUENCE pontigenyles_id_seq;
      ALTER TABLE pontigenyles ALTER id SET DEFAULT nextval('pontigenyles_id_seq');
      SELECT setval('pontigenyles_id_seq', COALESCE((SELECT MAX(id) FROM pontigenyles), 1));

      CREATE SEQUENCE ertekeles_uzenet_id_seq;
      ALTER TABLE ertekeles_uzenet ALTER id SET DEFAULT nextval('ertekeles_uzenet_id_seq');
      SELECT setval('ertekeles_uzenet_id_seq', COALESCE((SELECT MAX(id) FROM ertekeles_uzenet), 1));
    SQL
    Evaluation.connection.execute(sql)
  end

  def down
    sql = <<-SQL.squish
      ALTER TABLE belepoigenyles ALTER id DROP DEFAULT;
      DROP SEQUENCE belepoigenyles_id_seq;

      ALTER TABLE pontigenyles ALTER id DROP DEFAULT;
      DROP SEQUENCE pontigenyles_id_seq;

      ALTER TABLE ertekeles_uzenet ALTER id DROP DEFAULT;
      DROP SEQUENCE ertekeles_uzenet_id_seq;
    SQL
    Evaluation.connection.execute(sql)
  end
end
