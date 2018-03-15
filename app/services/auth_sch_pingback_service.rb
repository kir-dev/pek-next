class AuthSchPingbackService

  def self.call(access_token)
    EventMachine.run {
      http = EventMachine::HttpRequest.new(Rails.configuration.x.auth_sch_pingback_url + access_token).get
      http.errback {
        Rails.logger.error 'Auth.sch pingback failed'
        EventMachine.stop
      }
      http.callback {
        EventMachine.stop
      }
    }
  end

end
