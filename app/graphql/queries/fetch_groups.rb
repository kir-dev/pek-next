module Queries
  class FetchGroups < Queries::BaseQuery
    type [Types::GroupType], null: false

    def resolve
      Group.all
    end
  end
end