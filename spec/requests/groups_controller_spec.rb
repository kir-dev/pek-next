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
    it 'makes few queries' do
      expect {get "/groups/#{group.id}"}.to make_database_queries(count: 1)
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

  describe '#new' do
    context 'when the user is not pek_admin' do
      it 'returns forbidden' do
        get '/groups/new'

        expect(response).to have_http_status :forbidden
      end
    end

    context 'when the user is pek_admin' do
      let(:pek_admin) { create(:user, :pek_admin) }
      before          { login_as(pek_admin) }
      it 'renders the page' do
        get '/groups/new'

        expect(response).to have_http_status :ok
        expect(response).to render_template :new
      end
    end
  end

  describe '#create' do
    context 'when the user is not pek_admin' do
      it 'returns forbidden' do
        post '/groups'

        expect(response).to have_http_status :forbidden
      end
    end

    context 'when the user is pek_admin' do
      let(:pek_admin) { create(:user, :pek_admin) }
      let(:leader)    { create(:user) }
      before          { login_as(pek_admin) }
      it 'creates the group and notifies the leader' do
        expect_any_instance_of(Membership).to receive(:notify).and_call_original

        expect {
          post '/groups', params: {
              group:            attributes_for(:group),
              selected_user_id: leader.id
          }
        }.to change(Group, :count).by(1)
         .and change { leader.notifications.count }.by(1)
      end
    end
  end
end
