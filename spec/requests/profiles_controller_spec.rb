# frozen_string_literal: true

describe ProfilesController do
  let(:user)        { create(:user) }
  let!(:other_user) { create(:user) }
  before { login_as(user) }

  describe '#show_self' do
    it 'shows the own profile of the user' do
      get "/profiles/#{user.screen_name}"

      expect(response).to have_http_status(:ok)
    end

    context 'when the screenname is invalid' do
      it 'redirects to own profile' do
        get '/profiles/dummy'

        expect(response).to redirect_to(profiles_me_path)
      end
    end
  end

  describe '#show' do
    it 'shows the profile of the user' do
      get "/profiles/#{other_user.screen_name}"

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    it 'renders the page' do
      get "/profiles/#{user.screen_name}/edit"

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    it 'updates the user' do
      patch "/profiles/#{user.screen_name}", params: {
        profile: { firstname: 'Happy' }
      }

      expect(user.reload.firstname).to eq 'Happy'
    end

    it 'redirects to profile path' do
      patch "/profiles/#{user.screen_name}", params: {
        profile: { firstname: 'Happy' }
      }

      expect(response).to redirect_to(profiles_me_path)
    end
  end
end
