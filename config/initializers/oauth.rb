module OmniAuth
  module Strategies
    class Oauth < OmniAuth::Strategies::OAuth2
      option :name, "oauth"
      option :client_options, {
        :site => 'https://auth.sch.bme.hu',
        :authorize_url => "/site/login", 
        :token_url => "/oauth2/token"
      }
      option :authorize_params, {grant_type: 'authorization_code', scope: ENV['AUTH_SCH_SCOPES']}
      option :provider_ignores_state, true

      def request_phase
        redirect client.auth_code.authorize_url(authorize_params)
      end

      def authorize_params
        super.tap do |params|
          if request.params['scope']
            params[:scope] = request.params['scope']
          end
        end
      end

      uid { raw_info['internal_id'].to_s }

      info do
        {
          :id => raw_info['internal_id'],
          :email => raw_info['mail'],
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        access_token.options[:parse] = :json

        session[:access_token] = access_token.token
        url = "/api/profile"
        params = {:params => { :access_token => access_token.token}}
        @raw_info ||=  MultiJson.decode(access_token.client.request(:get, url, params).body)
      end

    end
  end
end