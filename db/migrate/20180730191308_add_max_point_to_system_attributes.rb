class AddMaxPointToSystemAttributes < ActiveRecord::Migration
  def change
    SystemAttribute.create(id: 123, name: 'max_point_for_semester', value: 100)
  end
end
