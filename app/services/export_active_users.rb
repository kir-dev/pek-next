class ExportActiveUsers
  attr_reader :semester

  def initialize(semester)
    @semester = semester
  end

  def self.call(semester)
    new(semester).call
  end

  def call
    result = []
    result << ["Név","Email"]
    users = User.joins(:point_history).where("point_histories.point > 0")
                .where("point_histories.semester": [SystemAttribute.semester.previous.to_s, SystemAttribute.semester.to_s])
                .order(:lastname).distinct

    users.each do |user|
      result << [user.full_name, user.email]
    end
    result
  end
end
