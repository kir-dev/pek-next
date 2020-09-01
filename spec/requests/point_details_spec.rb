require 'rails_helper'

RSpec.describe "PointDetails", type: :request do
  describe "#update" do
    let(:point_detail) { create(:point_detail) }
    let(:point_request) { point_detail.point_request }
    let(:evaluation) { point_request.evaluation }
    let(:group) { evaluation.group }
    let(:principle) { point_detail.principle }
    let(:point) { principle.max_per_member }
    let(:point_detail_user) { point_request.user }
    let(:arguments) do
      ["/groups/#{group.id}/evaluations/#{evaluation.id}/pointdetails/update",
       params: {
           user_id:       point_detail_user.id,
           principle_id:  principle.id,
           evaluation_id: evaluation.id,
           point:         point
       },
       headers: { "ACCEPT" => "application/js" }]
    end

    before(:each) { login_as(current_user) }

    context "when the user has no permission" do
      let(:current_user) { create(:user) }

      it "it returns forbidden" do
        post *arguments

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when the current user is the group leader" do
      let(:current_user) { group.leader.user }

      context "when off season" do
        include_context "off season"

        it "it redirects to root" do
          post *arguments

          expect(response).to redirect_to(root_url)
        end
      end

      context "when application season" do
        include_context "application season"

        context "when the point detail already excists" do
          it "it updates" do
            post *arguments

            expect(response).to have_http_status(:ok)
          end

          it "it doesn't change the PointDetail count" do
            expect { post *arguments }.to_not change { PointDetail.count }
          end

          it "it has the correct attributes" do
            post *arguments

            expect(PointDetail.last).to have_attributes(
              principle_id: principle.id,
              point:        point)
          end

          it "belong to the correnct user" do
            post *arguments

            expect(PointDetail.last.point_request.user).to eql(point_detail_user)
          end
        end

        context "when the user is a group member" do
          let(:point_detail_user) do
            user = create(:user)
            Membership::CreateService.call(group, user)
            user.membership_for(group).accept!
            user
          end

          it "it updates" do
            post *arguments

            expect(response).to have_http_status(:ok)
          end

          it "it creates a PointDetail" do
            expect { post *arguments }.to change { PointDetail.count }.by(1)
          end

          it "it has the correct attributes" do
            post *arguments

            expect(PointDetail.last).to have_attributes(
              principle_id: principle.id,
              point:        point)
          end

          it "belong to the correnct user" do
            post *arguments

            expect(PointDetail.last.point_request.user).to eql(point_detail_user)
          end
        end

        context "when the user is not a group member" do
          let(:point_detail_user) { create(:user) }

          it "it's unprocessable" do
            post *arguments

            expect(response).to have_http_status(:unprocessable_entity)
          end

          it "it doesn't change the PointDetail count" do
            expect { post *arguments }.to_not change { PointDetail.count }
          end

          it "it doesn't affect the attributes" do
            expect_any_instance_of(PointDetail).not_to receive(:changes_applied)

            post *arguments
          end

          it "it doesn't belong to the user" do
            post *arguments

            expect(PointDetail.last.point_request.user.id).not_to eql(point_detail_user.id)
          end
        end
      end

      context "when evaluation season" do
        include_context "evaluation season"

        it "it redirects" do
          post *arguments

          expect(response).to redirect_to(root_url)
        end

        context "when point request rejected" do
          before(:each) do
            evaluation.update(point_request_status: Evaluation::REJECTED)
          end

          it "it updates" do
            post *arguments

            expect(response).to have_http_status(:ok)
          end
        end
      end
    end

    context "when the user is leader for another group" do
      let(:current_user) { group.leader.user }
      let(:group) { create(:group) }

      context "when off season" do
        include_context "off season"

        it "it redirects to root" do

          post *arguments

          expect(response).to redirect_to(root_url)
        end
      end

      context "when application season" do
        include_context "application season"

        it "it's forbidden" do
          post *arguments

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "when evaluation season" do
        include_context "evaluation season"

        it "it redirects" do
          post *arguments

          expect(response).to redirect_to(root_url)
        end

        context "when point request rejected" do
          before(:each) do
            evaluation.update(point_request_status: Evaluation::REJECTED)
          end

          it "it's forbidden" do
            post *arguments

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context "when the user is the resort leader" do
      let(:current_user) { group.parent.leader.user }

      context "when off season" do
        include_context "off season"

        it "it redirects to root" do
          post *arguments

          expect(response).to redirect_to(root_url)
        end
      end

      context "when application season" do
        include_context "application season"

        it "it updates" do
          post *arguments

          expect(response).to have_http_status(:ok)
        end
      end

      context "when evaluation season" do
        include_context "evaluation season"

        it "it redirects" do
          post *arguments

          expect(response).to redirect_to(root_url)
        end

        context "when point request rejected" do
          before(:each) do
            evaluation.update(point_request_status: Evaluation::REJECTED)
          end

          it "it updates" do
            post *arguments

            expect(response).to have_http_status(:ok)
          end
        end
      end
    end

    context "when the user is the leader of another resort" do
      let(:current_user) { group.parent.leader.user }
      let(:group) { create(:group) }

      context "when off season" do
        include_context "off season"

        it "it redirects to root" do
          post *arguments

          expect(response).to redirect_to(root_url)
        end
      end

      context "when application season" do
        include_context "application season"

        it "it's forbidden" do
          post *arguments

          expect(response).to have_http_status(:forbidden)
        end
      end

      context "when evaluation season" do
        include_context "evaluation season"

        it "it redirects" do
          post *arguments

          expect(response).to redirect_to(root_url)
        end

        context "when point request rejected" do
          before(:each) do
            evaluation.update(point_request_status: Evaluation::REJECTED)
          end

          it "it's forbidden" do
            post *arguments

            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end
  end
end
