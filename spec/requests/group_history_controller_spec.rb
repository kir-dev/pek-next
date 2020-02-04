# frozen_string_literal: true

describe GroupHistoryController do
  describe '#show' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    subject { get "/groups/#{group.id}/history" }

    before { login_as(user) }

    context 'when the group has minimum one evaluation' do
      before { group.evaluations << create(:evaluation, point_request_status: Evaluation::ACCEPTED) }
      before { subject }

      it 'renders the page' do
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end
    end

    context 'when the group has no evaluation' do
      before { subject }

      it 'redirects with an alert' do
        expect(flash[:alert]).to be_present
        expect(response).to redirect_to(group_path(group))
      end
    end
  end
end
