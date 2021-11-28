describe PostsController do

  describe '#all_posts' do
    before(:each) do
      login_as(user)
    end
    let(:user) { group.leader.user }

    context 'when the group exists' do
      let(:group) { create(:group) }

      it 'is ok' do
        get "/groups/#{group.id}/group_posts"

        expect(response).to have_http_status :ok
        expect(response).to render_template :group_posts
      end
    end
  end
end
