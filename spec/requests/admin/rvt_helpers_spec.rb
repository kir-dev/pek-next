require 'rails_helper'

RSpec.describe "Admin::RvtHelpers", type: :request do
  before(:each) do
    login_as(current_user)
  end

  describe "GET /index" do
    context 'when the user has no privileges' do
      let(:current_user) { create(:user) }

      it 'is forbidden' do
        get '/admin/rvt_helpers'

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is the rvt leader' do
      let(:current_user) { Group.rvt.leader.user }

      it 'is ok' do
        get '/admin/rvt_helpers'

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /add' do
    context 'when the user is the RVT leader' do
      let(:current_user) { Group.rvt.leader.user }
      let(:user) { create(:user) }\

      it 'sets the rvt_helper field to true' do
        post "/admin/rvt_helpers/#{user.id}/add"

        expect(response).to have_http_status(:no_content)
        expect(user.reload.rvt_helper).to be true
      end
    end
  end

  describe 'POST /remove' do
    context 'when the user is the RVT leader' do
      let(:current_user) { Group.rvt.leader.user }
      let(:user) { create(:user, rvt_helper: true) }\

      it 'sets the rvt_helper field to true' do
        post "/admin/rvt_helpers/#{user.id}/remove"

        expect(response).to have_http_status(:no_content)
        expect(user.reload.rvt_helper).to be false
      end
    end
  end
end
