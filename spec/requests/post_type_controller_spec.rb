# frozen_string_literal: true

describe PostTypesController do
  describe '#index' do
    context 'when the user is not the group leader' do
      it 'returns forbidden' do
        user  = create(:user)
        group = create(:group)
        login_as(user)

        get "/groups/#{group.id}/post_types"

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is the group leader' do
      let(:group) { create(:group) }
      let(:user) { group.leader.user }
      before(:each) { login_as(user) }

      it 'returns ok and renders the list of post types' do
        get "/groups/#{group.id}/post_types"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      it 'returns forbidden for accessing post types for other group' do
        other_group = create(:group)

        get "/groups/#{other_group.id}/post_types"

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#create' do
    context 'when the user is non-leader' do
      it 'returns forbidden' do
        user  = create(:user)
        group = create(:group)
        login_as(user)

        post "/groups/#{group.id}/post_types", params: {
          post_type: { name: 'fontos' }
        }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is the group leader' do
      let(:group) { create(:group) }
      let(:user) { group.leader.user }
      before(:each) { login_as(user) }

      it 'redirects back' do
        post "/groups/#{group.id}/post_types", params: {
          post_type: { name: 'fontos' }
        }

        expect(response).to redirect_to(group_path(group))
      end

      it 'creates a new post type' do
        post_type_count = PostType.count
        post "/groups/#{group.id}/post_types", params: {
          post_type: { name: 'nagyon fontos' }
        }

        expect(PostType.count).to equal(post_type_count + 1)
      end

      context 'and empty name is provided' do
        it 'redirects back with error message' do
          post "/groups/#{group.id}/post_types", params: {
            post_type: { name: '' }
          }

          expect(response).to redirect_to(group_path(group))
          expect(flash[:alert]).to be_present
        end
      end

      context 'and they try to create it for another group' do
        it 'returns forbidden' do
          other_group = create(:group)

          post "/groups/#{other_group.id}/post_types", params: {
            post_type: { name: 'fontos' }
          }

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe '#destroy' do
    context 'when the user is non-leader' do
      it 'returns forbidden' do
        group      = create(:group)
        post_type  = create(:post_type, group_id: group.id)
        other_user = create(:user)
        login_as(other_user)

        delete "/groups/#{group.id}/post_types/#{post_type.id}"

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when the user is the group leader' do
      let(:group) { create(:group) }
      let(:user) { group.leader.user }
      let(:post_type) { create(:post_type, group_id: group.id) }
      before(:each) { login_as(user) }

      context 'when the post type is not in common types' do
        it 'actually deletes the post type' do
          delete "/groups/#{group.id}/post_types/#{post_type.id}"

          expect(PostType.where(id: post_type.id)).not_to exist
        end
      end

      context 'when the post type is in common types' do
        it 'does not delete the post type' do
          leader_post_id = PostType::LEADER_POST_ID

          delete "/groups/#{group.id}/post_types/#{leader_post_id}"

          expect(PostType.where(id: leader_post_id)).to exist
        end
      end

      context 'when the post type does not belong to the group' do
        it 'does not delete the post type' do
          other_post_type = create(:post_type)

          delete "/groups/#{group.id}/post_types/#{other_post_type.id}"

          expect(PostType.where(id: post_type.id)).to exist
        end
      end

      context 'when the post type is in use' do
        it 'does not delete the post type' do
          post = create(:post, post_type_id: post_type.id)
          post_type.posts << post

          delete "/groups/#{group.id}/post_types/#{post_type.id}"

          expect(PostType.where(id: post_type.id)).to exist
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
