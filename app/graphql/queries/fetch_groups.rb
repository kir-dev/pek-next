module Queries
  class FetchGroups < Queries::BaseQuery
    type Types::GroupType.connection_type, null: false

    def resolve
      Group.all
    end
  end
end