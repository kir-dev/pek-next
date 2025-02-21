class ExportUsersWithAb
  attr_reader :semester

  def initialize(semester)
    @semester = semester
  end

  def self.call(semester)
    new(semester).call
  end

  def call
    result = []
    result << ["Név", "Email", "Kör", "Indoklás"]
    entry_requests = EntryRequest.includes({evaluation: :group},:user)
                .where("evaluations.semester": SystemAttribute.semester.to_s,
                       "evaluations.entry_request_status": Evaluation::ACCEPTED,
                       entry_type: "AB")
                .order("groups.name", "users.lastname")

    entry_requests.each do |entry_request|
      result << [entry_request.user.full_name, entry_request.user.email, entry_request.evaluation.group.name, entry_request.justification]
    end
    result
  end
end
