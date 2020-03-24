# frozen_string_literal: true

describe MembershipsController do
  shared_context 'current_user is the group leader' do
    let(:group)   { membership.group }
    before(:each) { login_as(group.leader.user) }
  end

  shared_context 'current_user is not a member' do
    let(:group)   { create(:group) }
    let(:user)    { create(:user) }
    before(:each) { login_as(user) }
  end

  shared_context 'current_user is a member' do
    let(:group)   { membership.group }
    let(:user)    { membership.user }
    before(:each) { login_as(user) }
  end

  describe '#create' do
    context 'when membership is not created and current_user is not a member' do
      include_context 'current_user is not a member'

      it 'creates membership' do
        post "/groups/#{group.id}/memberships"
        user.memberships.reload

        expect(group.leader.user.notifications.count).to be 1
        expect(user.membership_for(group)).not_to be_nil
        expect(response).to redirect_to group_path(group)
      end
    end

    context 'when membership already created and current_user is member' do
      include_context 'current_user is a member'
      let(:membership) { create(:membership) }

      it 'it returns forbidden' do
        post "/groups/#{group.id}/memberships"

        expect(Membership.where(group: group, user: user).count).to eq(1)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when membership is archived and current_user is member' do
      include_context 'current_user is a member'
      let(:membership) { create(:membership, :archived) }

      it 'notifies the group leader' do
        expect_any_instance_of(Membership).to receive(:notify).and_call_original

        expect {
          post "/groups/#{membership.group.id}/memberships", xhr: true
        }.to change { group.leader.user.notifications.count }.by(1)
      end
    end

    context 'when membership is archived, newbie and current_user is member' do
      include_context 'current_user is a member'
      let(:membership) { create(:membership, :archived, :newbie) }

      it 'it returns forbidden' do
        expect_any_instance_of(Membership).not_to receive(:notify).and_call_original

        expect {
          post "/groups/#{membership.group.id}/memberships", xhr: true
        }.to_not change{ group.leader.user.notifications.count }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#accept' do
    context 'when membership is newbie and current_user is the group leader' do
      include_context 'current_user is the group leader'
      let(:membership) { create(:membership, :newbie) }

      it 'accepts the membership' do
        post "/groups/#{group.id}/memberships/#{membership.id}/accept", xhr: true
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when membership is newbie and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership, :newbie) }

      it 'it returns forbidden' do
        post "/groups/#{group.id}/memberships/#{membership.id}/accept", xhr: true
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#archive' do
    context 'when membership is newbie and current_user is the group leader ' do
      include_context 'current_user is the group leader'
      let(:membership) { create(:membership, :newbie) }

      it 'archives the membership' do
        Timecop.freeze do
          put "/groups/#{group.id}/memberships/#{membership.id}/archive", xhr: true

          expect(membership.reload.archived.today?).to be true
        end
        expect(response).to have_http_status(:success)
      end
    end

    context 'when membership is newbie and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership, :newbie) }

      it 'it returns forbidden' do
        put "/groups/#{group.id}/memberships/#{membership.id}/archive", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when membership is inactive and current_user is the group leader' do
      let(:membership) { create(:membership, :inactive) }
      include_context 'current_user is the group leader'

      it 'archives the membership' do
        Timecop.freeze do
          put "/groups/#{membership.group.id}/memberships/#{membership.id}/archive", xhr: true

          expect(membership.reload.archived.today?).to be true
        end
        expect(response).to have_http_status(:success)
      end
    end

    context 'when membership is inactive and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership, :inactive) }

      it 'it returns forbidden' do
        put "/groups/#{membership.group.id}/memberships/#{membership.id}/archive", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#unarchive' do
    context 'when membership archived and active and current_user is the group leader' do
      include_context 'current_user is the group leader'
      let(:membership) { create(:membership, :archived) }

      it 'unarchives the membership' do
        put "/groups/#{membership.group.id}/memberships/#{membership.id}/unarchive", xhr: true

        expect(membership.reload.archived).to be_nil
        expect(response).to have_http_status(:success)
      end
    end

    context 'when membership archived and active and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership, :archived) }

      it 'returns forbidden' do
        put "/groups/#{membership.group.id}/memberships/#{membership.id}/unarchive", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when membership archived and inactive and current_user is the group leader' do
      include_context 'current_user is the group leader'
      let(:membership) { create(:membership, :inactive, :archived) }

      it 'unarchives the membership' do
        put "/groups/#{membership.group.id}/memberships/#{membership.id}/unarchive", xhr: true

        expect(response).to have_http_status(:success)
      end
    end

    context 'when membership archived and inactive current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership, :inactive, :archived) }

      it 'returns forbidden' do
        put "/groups/#{membership.group.id}/memberships/#{membership.id}/unarchive", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when membership belongs to leader and current_user is the group leader' do
      include_context 'current_user is the group leader'
      let(:membership) { create(:membership, :leader) }

      it 'returns forbidden' do
        put "/groups/#{membership.group.id}/memberships/#{membership.id}/unarchive", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when membership belongs to leader and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership, :leader) }

      it 'returns forbidden' do
        put "/groups/#{membership.group.id}/memberships/#{membership.id}/unarchive", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#incactivate' do
    context 'when membership has no traits and current_user is the group leader' do
      include_context 'current_user is the group leader'
      let(:membership) { create(:membership) }

      it 'inactivates the membership' do
        Timecop.freeze do
          post "/groups/#{membership.group.id}/memberships/#{membership.id}/inactivate", xhr: true

          expect(membership.reload.end_date.today?).to be true
        end
        expect(response).to have_http_status(:success)
      end
    end

    context 'when membership has no traits and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership) }

      it 'it returns forbidden' do
        post "/groups/#{membership.group.id}/memberships/#{membership.id}/inactivate", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'membership for user who is delegated to that group and current_user is the group leader' do
      include_context 'current_user is the group leader'
      let(:membership) { user.primary_membership }
      let(:user) { create(:user, :who_delegated) }

      it 'delegation became false' do
        Timecop.freeze do
          post "/groups/#{membership.group.id}/memberships/#{membership.id}/inactivate", xhr: true

          expect(membership.reload.user.delegated).to be false
        end
        expect(response).to have_http_status(:success)
      end
    end

    context 'membership for user who is delegated to that group and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:user) { create(:user, :who_delegated) }
      let(:membership) { user.primary_membership }

      it 'it returns forbidden' do
        post "/groups/#{membership.group.id}/memberships/#{membership.id}/inactivate", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#reactivate' do
    context 'when membership has no traits and current_user is the group leader' do
      include_context 'current_user is the group leader'
      let(:membership) { create(:membership, :inactive) }

      it 'reactivates the membership' do
        post "/groups/#{membership.group.id}/memberships/#{membership.id}/reactivate", xhr: true

        expect(membership.reload.end_date).to be_nil
        expect(response).to have_http_status(:success)
      end
    end

    context 'when membership has no traits and current_user is not a member' do
      include_context 'current_user is not a member'
      let(:membership) { create(:membership, :inactive) }

      it 'it returns forbidden' do
        post "/groups/#{membership.group.id}/memberships/#{membership.id}/reactivate", xhr: true

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
