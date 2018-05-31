class ChangeIdToAutoIncrementInEvaluations < ActiveRecord::Migration

  def up
    sql = <<-SQL.squish
      CREATE SEQUENCE ertekelesek_id_seq;
      ALTER TABLE ertekelesek ALTER id SET DEFAULT nextval('ertekelesek_id_seq');
      SELECT setval('ertekelesek_id_seq', COALESCE((SELECT MAX(id) FROM ertekelesek), 1));
    SQL
    Evaluation.connection.execute(sql)
  end

  def down
    sql = <<-SQL.squish
      ALTER TABLE ertekelesek ALTER id DROP DEFAULT;
      DROP SEQUENCE ertekelesek_id_seq;
    SQL
    Evaluation.connection.execute(sql)
  end

end
