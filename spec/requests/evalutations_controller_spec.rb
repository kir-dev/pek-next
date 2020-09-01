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
      include_context "application season"
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
    end

    context 'when the user is the resort leader' do
      include_context "application season"
      let(:user) { group.parent.leader.user }
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
    end
  end
end
