module Types
  class MutationType < Types::BaseObject
    field :sign_in, resolver: Mutations::SignInMutation do
      description 'Sign in with access token'
    end
  end
end
