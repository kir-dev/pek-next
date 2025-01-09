# frozen_string_literal: true

describe "EntryRequests", type: :request do
  let(:entry_request) { create(:entry_request, justification: "He did a really good job", entry_type: "AB") }
  let(:evaluation) { entry_request.evaluation }
  let(:group) { evaluation.group }
  let(:selected_user) { entry_request.user }

  before(:each) do
    login_as(current_user)
    evaluation.update!(semester: SystemAttribute.semester.to_s)
  end

  describe "#update" do
    include_context "application season"

    subject do
      post "/groups/#{group.id}/evaluations/#{evaluation.id}/entryrequests/update",
           params: {
             user_id: selected_user.id,
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

  describe "#review" do
    include_context "evaluation season"

    subject do
      get review_entry_requests_path
    end

    context "when the current_user is the RVT leader" do
      let(:current_user) { Group.rvt.leader.user }

      it 'returns the entry requests for the semester' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:review)
        expect(response.body).to include("He did a really good job")
      end
    end
  end

  describe "#update_review" do
    include_context "evaluation season"
    context "when the current_user is the RVT leader" do
      let(:current_user) { Group.rvt.leader.user }

      it 'returns the entry requests for the semester' do
        put update_review_entry_request_path(entry_request),
            params: { entry_request: {entry_type: 'KB', justification: 'Reviewed', finalized: true}, recommendations: [] }

        expect(entry_request.reload).to have_attributes(entry_type: 'KB', justification: 'Reviewed', finalized: true)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the current_user is the a resort leader" do
      let(:current_user) { Group.sssl.leader.user }

      it 'returns the entry requests for the semester' do
        put update_review_entry_request_path(entry_request),
            params: { entry_request: {entry_type: 'KB', justification: 'Reviewed', finalized: true},
                      recommendations: [{resort_id: "18", value: "KB"}] }

        expect(entry_request.reload).to have_attributes(justification: "He did a really good job", entry_type: "AB",
                                                        recommendations: {"18" => "KB"} )
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
