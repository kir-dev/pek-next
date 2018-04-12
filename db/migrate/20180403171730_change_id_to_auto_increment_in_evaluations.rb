class ChangeIdToAutoIncrementInEvaluations < ActiveRecord::Migration
  def change
    sql = <<-SQL.squish
      CREATE SEQUENCE ertekelesek_id_seq;
      ALTER TABLE ertekelesek ALTER id SET DEFAULT nextval('ertekelesek_id_seq');
    SQL
    Evaluation.connection.execute(sql)
  end
end
