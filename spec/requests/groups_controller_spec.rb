# frozen_string_literal: true

describe GroupsController do
  let(:user)  { create(:user) }
  let(:group) { create(:group) }
  before      { login_as(user) }

  describe '#index' do
    it 'shows active groups list' do
      get '/groups'

      expect(response).to have_http_status :ok
      expect(response).to render_template :index
    end
  end

  describe '#all' do
    it 'shows all groups list' do
      get '/groups/all'

      expect(response).to have_http_status :ok
      expect(response).to render_template :index
    end
  end

  describe '#show' do
    it 'shows a group' do
      get "/groups/#{group.id}"

      expect(response).to have_http_status :ok
    end
  end

  describe '#edit' do
    context 'when the user is not the leader' do
      it 'returns forbidden' do
        get "/groups/#{group.id}/edit"

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is the group leader' do
      let(:leader) { group.leader.user }
      before       { login_as(leader) }
      it 'renders the page' do
        get "/groups/#{group.id}/edit"

        expect(response).to have_http_status :ok
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#update' do
    context 'when the user is not the leader' do
      it 'returns forbidden' do
        patch "/groups/#{group.id}"

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is the group leader' do
      let(:leader) { group.leader.user }
      before       { login_as(leader) }
      it 'updates the group' do
        patch "/groups/#{group.id}", params: {
          group: {
            name:                     'New name',
            description:              'New description',
            webpage:                  'www.example.org',
            founded:                  2000,
            maillist:                 'mail@list.org',
            users_can_apply:          true,
            archived_members_visible: true
          }
        }

        expect(response).to redirect_to(group_path(group))

        group.reload
        expect(group.name).to eq 'New name'
        expect(group.description).to eq 'New description'
        expect(group.webpage).to eq 'www.example.org'
        expect(group.founded).to eq 2000
        expect(group.maillist).to eq 'mail@list.org'
        expect(group.users_can_apply).to eq true
        expect(group.archived_members_visible).to eq true
      end
    end
  end
end
