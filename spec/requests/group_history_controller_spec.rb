# frozen_string_literal: true

describe GroupHistoryController do
  describe '#show' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    subject { get "/groups/#{group.id}/history" }

    before { login_as(user) }

    context 'when everything is fine' do
      before { group.evaluations << create(:evaluation, point_request_status: Evaluation::ACCEPTED) }
      before { subject }

      it 'works fine' do
        expect(response).to have_http_status(:ok)
      end

      it { should render_template :show }
    end

    context 'when group does not have any evaluation' do
      before { subject }

      it 'shows notice' do
        expect(flash[:alert]).to be_present
      end

      it { should redirect_to(group_path(group)) }
    end
  end
end
