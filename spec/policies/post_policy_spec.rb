describe PostPolicy, type: :policy do
  subject { described_class }

  permissions :create?, :destroy? do
    let(:membership) { create(:membership) }
    let(:post_type) { create(:post_type, group: membership.group) }
    let(:post) { create(:post, membership: membership, post_type: post_type) }

    context "when the current user is the group leader" do
      let(:user) { membership.group.leader.user }

      it "is permitted" do
        expect(subject).to permit(user, post.reload)
      end
    end

    context "when the user is not a member" do
      let(:user) { create(:user) }
      it "is forbidden" do
        expect(subject).not_to permit(user, post)
      end
    end

    context "when the group is the SSSL" do
      let(:membership) { create(:membership, group: Group::sssl) }

      context "and the current user is the evaluation helper" do
        before(:each) do
          membership = Membership.create!(user: user, group: Group::sssl)
          Post.create!(membership: membership, post_type_id: PostType::EVALUATION_HELPER_ID)
        end

        let(:user) { create(:user) }

        it "is permitted" do
          expect(subject).to permit(user, post)
        end
      end
    end
  end
end
