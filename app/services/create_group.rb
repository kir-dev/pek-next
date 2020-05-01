class CreateGroup
  def self.call(group_params, leader_user, current_user)
    ActiveRecord::Base.transaction do
      group             = Group.create!(group_params)
      leader_membership = Membership.create!(group: group, user: leader_user)
      Post.create!(membership_id: leader_membership.id, post_type_id: PostType::LEADER_POST_ID)

      leader_membership.notify(:users, key: 'membership.create', notifier: current_user)
      group
    end
  end
end
