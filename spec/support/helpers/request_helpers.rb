# frozen_string_literal: true

module RequestHelpers
  def json_body
    @json_body ||= JSON.parse(response.body)
  end
end
