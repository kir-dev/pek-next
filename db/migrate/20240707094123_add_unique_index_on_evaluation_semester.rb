class AddUniqueIndexOnEvaluationSemester < ActiveRecord::Migration[6.0]
  # We have multiple evaluations for the same group in the same semester from previous years,
  # this prevents us from using a unique index on [:group_id, :semester].
  # The idx_in_semester columns solves this by setting an arbitrary value where duplication is present and
  # 0 for cases with no duplication.'
  def up
    add_column :evaluations, :idx_in_semester, :integer, default: 0, null: false

    evaluation_groups = Evaluation.all.group_by { |evaluation| [evaluation.group_id, evaluation.semester] }
    evaluation_groups.each do |id, evaluations|
      evaluations.each.with_index do |evaluation, index|
        evaluation.update!(idx_in_semester: index)
      end
    end

    add_index :evaluations, [:group_id, :semester, :idx_in_semester], unique: true
  end

  def down
    remove_index :evaluations, column: [:group_id, :semester, :idx_in_semester]
    remove_column :evaluations, :idx_in_semester
  end
end
