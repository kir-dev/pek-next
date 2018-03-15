class DetailedPointHistory
  def initialize(pointrequest)
    @pointrequest = pointrequest
    @evaluation = Evaluation.find(@pointrequest.evaluation_id)
    @group = Group.find(@evaluation.group_id)
  end

  def group_name
    @group.grp_name
  end

  def group_id
    @group.id
  end

  def semester
    Semester.new(@evaluation.date).to_readable
  end

  def point
    @pointrequest.point
  end
end
