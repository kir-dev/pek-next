# frozen_string_literal: true

describe EvaluationsController do
  describe '#current' do
    let(:group) { create(:group) }

    context 'when the user is not the group leader' do
      it 'returns forbidden' do
        user = create(:user)
        login_as(user)

        get "/groups/#{group.id}/evaluations/current"

        expect(response).to have_http_status :forbidden
      end
    end

    context 'when the user is the group leader' do
      let(:user)    { group.leader.user }
      before(:each) { login_as(user) }

      it 'creates new evaluation' do
        get "/groups/#{group.id}/evaluations/current"

        new_evaluation = Evaluation.find_by(
          group: group, semester: SystemAttribute.semester.to_s
        )

        expect(new_evaluation).not_to be nil
      end

      it 'redirects to the evaluation page' do
        get "/groups/#{group.id}/evaluations/current"

        new_evaluation = Evaluation.find_by(
          group: group, semester: SystemAttribute.semester.to_s
        )

        expect(response).to redirect_to group_evaluation_path(group, new_evaluation)
      end

      it 'test a lot' do
        SystemAttribute.update_season(SystemAttribute::EVALUATION_SEASON)
        point_detail = create(:point_detail)
        evaluation = point_detail.point_request.evaluation
        evaluation.update(point_request_status: Evaluation::REJECTED)
        group = evaluation.group
        request_params = {principle_id: point_detail.principle_id, user_id: point_detail.point_request.user_id, point: 3}
        login_as(group.leader.user)

        number = 1000
        count = 0
        number.times do
          expect do
            puts "#{count += 1}/#{number}"
            evaluation.point_requests.each { |pr| pr.point_details.destroy_all }
            post "/groups/#{group.id}/evaluations/#{evaluation.id}/pointdetails/update", {params: request_params, xhr: true}
            expect(response).to have_http_status(:ok)

            post "/groups/#{group.id}/evaluations/#{evaluation.id}/pointdetails/update", {params: request_params, xhr: true}
            expect(response).to have_http_status(:ok)

          end.to change { PointDetail.count }.by(0)
        end
      end
    end
  end
end
