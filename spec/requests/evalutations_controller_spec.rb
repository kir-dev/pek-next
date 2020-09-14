# frozen_string_literal: true

describe EvaluationsController do

  shared_context "current user is the group leader" do
    let(:user) { group.leader.user }
  end
  before(:each) { login_as(user) }
  let(:group) { evaluation.group }
  let(:evaluation) { create(:evaluation) }

  describe '#current' do
    context 'when the user is not the group leader' do
      let(:user) { create(:user) }

      it 'returns forbidden' do
        get "/groups/#{group.id}/evaluations/current"

        expect(response).to have_http_status :forbidden
      end
    end

    context 'when the user is the group leader' do
      include_context "application season"
      include_context "current user is the group leader"

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

  describe "#show" do
    context "when evaluation exists and the current user is the group leader and off season " do
      include_context "current user is the group leader"

      it "shows the evaluation" do
        get "/groups/#{group.id}/evaluations/#{evaluation.id}"

        expect(response).to redirect_to(root_url)
      end
    end

    context "when evaluation exists and the current user is the group leader and application season " do
      include_context "application season"
      include_context "current user is the group leader"

      it "shows the evaluation" do
        get "/groups/#{group.id}/evaluations/#{evaluation.id}"

        expect(response).to have_http_status(:ok)
      end
    end

    context "when evaluation exists and the current user is the group leader and evaluation season " do
      include_context "evaluation season"
      include_context "current user is the group leader"

      it "shows the evaluation" do
        get "/groups/#{group.id}/evaluations/#{evaluation.id}"

        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "#submit_point_request" do

    context "when the current user is the group leader and off season" do
      include_context "current user is the group leader"
      include_context "off season"

      it "redirects" do
        post "/groups/#{group.id}/evaluations/#{evaluation.id}/pointrequest"

        expect(response).to redirect_to(root_url)
      end
    end

    context "when the current user is the group leader and application season" do
      include_context "current user is the group leader"
      include_context "application season"

      it "redirects" do
        post "/groups/#{group.id}/evaluations/#{evaluation.id}/pointrequest"

        expect(response).to redirect_to group_evaluation_path(group, evaluation)
      end
    end
  end
end
