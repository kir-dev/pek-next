class AddSubGroupToPrinciple < ActiveRecord::Migration[6.0]
  def change
    add_reference :principles, :sub_group, foreign_key: true
  end
end
