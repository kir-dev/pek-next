module Types
  class QueryType < Types::BaseObject
    field :groups, resolver: Queries::FetchGroups do
      description 'Find all group'
    end
  end
end
