class ExportPointHistory
  attr_reader :semester

  def initialize(semester)
    @semester = semester
  end

  def self.call(semester)
    new(semester).call
  end

  def call
    result = []
    result << ["PéK id", "Név", "Neptun", "BME-id", "Email", "Felvételi pont", "SVIE tagság", "Körök"]
    histories = PointHistory.includes(user: [point_requests: [evaluation: :group]]).where(semester: semester).where.not(point: 0)
    histories.map do |history|
      user = history.user
      point_requests = user.point_requests.select do |point_request|
        point_request.accepted? && point_request.evaluation.semester == semester
      end
      point_requests = point_requests.reject { |point_request| point_request.point == 0 }
      groups = point_requests.map { |point_request| point_request.evaluation.group.name }.join(',')
      email = URI::MailTo::EMAIL_REGEXP.match?(user.email) ? user.email : nil
      result << [user.id, user.full_name, user.neptun, user.bme_id, email, history.point, user.svie_member_type, groups]
    end
    result
  end
end
