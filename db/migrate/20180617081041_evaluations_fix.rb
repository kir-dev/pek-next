# TODO : delete this migration at next deploy (after it was run)
class EvaluationsFix < ActiveRecord::Migration
  def up
    this_semester = SystemAttribute.semester.to_s
    Evaluation.where(semester: this_semester).each do |e|
      e.justification = e.explanation
      e.explanation = nil

      e.save
    end
  end

  def down; end
end
