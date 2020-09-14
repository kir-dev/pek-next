# frozen_string_literal: true

describe "PointDetails" do
  describe "#update" do
    let(:point_detail) { create(:point_detail) }
    let(:evaluation) { point_detail.point_request.evaluation }
    let(:group) { evaluation.group }
    let(:params) do
      principle = point_detail.principle
      {
          user_id:       point_detail.point_request.user.id,
          principle_id:  principle.id,
          evaluation_id: evaluation.id,
          point:         principle.max_per_member
      }
    end

    subject do
      headers = { "ACCEPT" => "application/js" }
      post "/groups/#{group.id}/evaluations/#{evaluation.id}/pointdetails/update", params: params, headers: headers
    end

    before(:each) { login_as(current_user) }

    context "when the user has no permission" do
      let(:current_user) { create(:user) }

      it "returns forbidden" do
        subject

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when the current user is the group leader" do
      let(:current_user) { group.leader.user }

      context "when application season" do
        include_context "application season"

        context "when the point detail already exists" do
          it "updates the point detail" do
            subject

            expect(response).to have_http_status(:ok)
          end

          it "doesn't change the PointDetail count" do
            expect { subject }.to_not change { PointDetail.count }
          end

          it "has the correct attributes" do
            subject

            expected_attributes = { principle_id: params[:principle_id], point: params[:point] }
            expect(PointDetail.last).to have_attributes(expected_attributes)
          end

          it "belongs to the correct user" do
            subject

            expect(PointDetail.last.point_request.user).to eql(point_detail.point_request.user)
          end
        end
      end
    end
  end
end
