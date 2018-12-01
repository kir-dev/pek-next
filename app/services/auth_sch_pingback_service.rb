class AuthSchPingbackService
  def self.call(access_token)
    return if Rails.env.test?

    EventMachine.run do
      url = Rails.configuration.x.auth_sch_pingback_url + access_token
      http = EventMachine::HttpRequest.new(url).get
      http.errback do
        Rails.logger.error 'Auth.sch pingback failed'
        EventMachine.stop
      end
      http.callback do
        EventMachine.stop
      end
    end
  end
end
