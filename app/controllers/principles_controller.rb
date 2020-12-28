# This controller's actions are authenticated by the parent's policy. (EvaluationPolicy)
# WARNING: Renaming actions or implementing additional authentication could result unexpected behaviour!
class PrinciplesController < EvaluationsController
  before_action :set_principle, only: %i[update destroy]
  before_action :validate_correct_evaluation, only: %i[update destroy]

  def index
    @evaluation = current_evaluation
  end

  def update
    @principle.update(principle_params)
  end

  def create
    @principle = Principle.new(principle_params)
    @evaluation = current_evaluation
    @principle.evaluation = @evaluation
    @principle.save
  end

  def destroy
    @principle.destroy
  end

  private

  def set_principle
    @principle = Principle.find(params[:id])
  end

  def validate_correct_evaluation
    render forbidden_page unless current_evaluation == @principle.evaluation
  end

  def principle_params
    params.require(:principle).permit(:type, :name, :max_per_member, :description)
  end
end
