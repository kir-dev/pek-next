class PrinciplesController < EvaluationsController
  before_action :require_resort_or_group_leader
  before_action :validate_correct_group

  def index
    @evaluation = Evaluation.find(params[:evaluation_id])
  end

  def update
    @principle = Principle.find(params[:id])
    @principle.update(principle_params)
  end

  def create
    @principle = Principle.new(principle_params)
    @evaluation = Evaluation.find(params[:evaluation_id])
    @principle.evaluation = @evaluation
    @principle.save
  end

  def destroy
    @principle = Principle.find(params[:id])
    @principle.destroy
  end

  private
    def principle_params
      params.require(:principle).permit(:type, :name, :max_per_member, :description)
    end

end
