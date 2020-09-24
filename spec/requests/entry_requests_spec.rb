# frozen_string_literal: true

describe "EntryRequests", type: :request do
  let(:entry_request) { create(:entry_request) }
  let(:evaluation) { entry_request.evaluation }
  let(:group) { evaluation.group }
  let(:selected_user) { entry_request.user }

  before(:each) do
    login_as(current_user)
  end

  describe "#update" do
    include_context "application season"

    subject do
      post "/groups/#{group.id}/evaluations/#{evaluation.id}/entryrequests/update",
           params: {
               user_id:    selected_user.id,
               entry_type: EntryRequest::AB
           }
    end

    context "when the user is not authorized" do
      let(:current_user) { create(:user) }

      it "returns forbidden" do
        subject

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when the current_user is the group leader" do
      let(:current_user) { group.leader.user }

      it "updates the entry request" do
        subject

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
