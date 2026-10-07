# frozen_string_literal: true

class DestroyPostType
  def self.call(group, post_type)
    return false if PostType::COMMON_TYPES.include?(post_type.id) || post_type.group_id != group.id

    ActiveRecord::Base.transaction do
      post_type.posts.each(&:destroy) if post_type.posts.any?
      post_type.destroy
    end
  end
end
