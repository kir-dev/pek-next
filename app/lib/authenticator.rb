class Authenticator
  def initialize(connection = Faraday.new)
    @connection = connection
  end

  def authentication(access_token)
    user = fetch_user_info(access_token)
    {
      auth_sch_id: user['internal_id']
    }
  end

  private

  def fetch_user_info(access_token)
    response = @connection.get 'https://auth.sch.bme.hu/api/profile', {
      access_token: access_token
    }
    parsed_response = JSON.parse(response.body)
    raise IOError, parsed_response['error'] unless response.success?
    parsed_response
  end
end
