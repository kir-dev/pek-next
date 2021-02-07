module Queries
  class FetchGroups < Queries::BaseQuery
    argument :only_active, Boolean, required: false
    type Types::GroupType.connection_type, null: false

    def resolve(only_active: nil)
      return Group.order(:name).reject(&:inactive?) if only_active
      Group.order(:name)
    end
  end
end