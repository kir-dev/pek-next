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

      describe '#create' do
        let(:membership) { group.memberships.first }
        it 'creates a post and redirects' do
          expect {
            post "/groups/#{group.id}/memberships/#{membership.id}/posts",
                 params: { post_type_id: PostType::FINANCIAL_OFFICER_POST_ID }
          }.to change {
            membership.posts.count
          }.by(1)
          expect(response).to redirect_to("/groups/#{group.id}/memberships/#{membership.id}/posts")
        end

        it 'when the post is for the leader it redirects to the group page' do
          post "/groups/#{group.id}/memberships/#{membership.id}/posts",
               params: { post_type_id: PostType::LEADER_POST_ID }

          expect(response).to redirect_to("/groups/#{group.id}")
        end

        context 'when FINANCIAL_OFFICER is present' do
          before(:each) do
            CreatePost::call(group, membership, PostType::FINANCIAL_OFFICER_POST_ID)
          end
          it 'creating another FINANCIAL_OFFICER is not processed' do
            expect {
              post "/groups/#{group.id}/memberships/#{membership.id}/posts",
                   params: { post_type_id: PostType::FINANCIAL_OFFICER_POST_ID }
            }.to change {
              membership.posts.count
            }.by(0)

            expect(flash[:notice]).to eql(I18n.t('services.create_post.post_already_taken'))
            expect(response).to redirect_to("/groups/#{group.id}/memberships/#{membership.id}/posts")
          end
        end

        context 'when format is json ' do
          it 'sends back the post id' do
            post "/groups/#{group.id}/memberships/#{membership.id}/posts.json",
                 params: { post_type_id: PostType::FINANCIAL_OFFICER_POST_ID }

            expect(response.body).to eql({ post_id: Post.last.id }.to_json)
          end

          context 'when FINANCIAL_OFFICER is present' do
            before(:each) do
              CreatePost::call(group, membership, PostType::FINANCIAL_OFFICER_POST_ID)
            end
            it 'creating another FINANCIAL_OFFICER is forbidden' do
              post "/groups/#{group.id}/memberships/#{membership.id}/posts.json",
                   params: { post_type_id: PostType::FINANCIAL_OFFICER_POST_ID }

              expect(response).to have_http_status :forbidden
              expect(response.body).to eql({ message: I18n.t('services.create_post.post_already_taken') }.to_json)
            end
          end
        end
      end
    end
  end
end
