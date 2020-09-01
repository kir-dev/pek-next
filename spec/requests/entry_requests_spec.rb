require 'rails_helper'

RSpec.describe "EntryRequests", type: :request do
  let(:entry_request) { create(:entry_request) }
  let(:evaluation) { entry_request.evaluation }
  let(:group) { evaluation.group }
  let(:selected_user) { entry_request.user }
  let(:arguments) do
    ["/groups/#{group.id}/evaluations/#{evaluation.id}/entryrequests/update",
     params: {
         user_id:    selected_user.id,
         entry_type: EntryRequest::AB
     }]
  end

  before(:each) do
    login_as(current_user)
  end

  shared_context "application season" do
    before(:each) do
      SystemAttribute.update_season(SystemAttribute::APPLICATION_SEASON)
    end
  end

  describe "#update" do
    include_context "application season"


    context "when the user is not authorized" do
      let(:current_user) { create(:user) }

      it "it's forbidden" do
        post *arguments

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when the current_user is the group leader" do
      let(:current_user) { group.leader.user }

      it "it updates" do
        post *arguments

        expect(response).to have_http_status(:ok)
      end

      context "when the selected user isn't a member" do
        let(:selected_user) { create(:user) }

        it "it's unprocessable" do
          post *arguments

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "when the user is a leader of another group" do
      let(:current_user) { current_group.leader.user }
      let(:current_group) { create(:group) }

      it "it's forbidden" do
        post *arguments

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
