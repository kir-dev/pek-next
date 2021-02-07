module Types
  class GroupType < Types::BaseObject
    field :id, ID, null: false, description: "The ID of the Group"
    field :name, String, null: false
  end
end
