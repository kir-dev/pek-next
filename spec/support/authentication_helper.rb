# frozen_string_literal: true

module AuthenticationHelper
  def login_as(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:oauth, auth_hash_for(user))
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:oauth]
    get auth_oauth_callback_path
  end

  private

  def auth_hash_for(user)
    OmniAuth::AuthHash.new(
      provider: 'authsch',
      uid: '123545',
      info: {
        first_name: user.firstname,
        last_name: user.lastname,
        email: user.email
      },
      credentials: {
        token: '123456',
        expires_at: Time.now + 1.week
      },
      extra: {
        raw_info: {
          internal_id: user.auth_sch_id,
          email: user.email
        }
      }
    )
  end
end
