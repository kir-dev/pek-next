module Mutations
  class SignInMutation < Mutations::BaseMutation
    argument :access_token, String, required: true

    type Types::AuthPayloadType

    def resolve(access_token)
      authenticator = Authenticator.new
      user_info = authenticator.authentication(access_token)
      user = User.find_by(auth_sch_id: user_info[:auth_sch_id])
   
      if user 
        user.update_last_login!
        payload = { id: user.id }
        token = JWT.encode payload, "S3cR3T", 'HS256'
        {
          token: token
        }
      else
        # TODO: Registration
        {
          token: nil
        }
      end
    end
  end
end