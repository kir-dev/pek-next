namespace :data do
  namespace :migrate do
    desc 'Use for unifying new member post types'
    task new_member_posts: :environment do
      new_member_post_type_names = %w[újonc ujonc Újonc]
      new_member_post_types = PostType.where(name: new_member_post_type_names)
                                      .where.not(id: PostType::NEW_MEMBER_ID)
                                      .includes(:group)

      puts "\nThe following post types will be deleted:"
      new_member_post_types.each { |type| puts "#{type.id} - #{type.name} / #{type.group.name}" }

      puts 'Are you sure to continue? y/N'
      input = STDIN.gets.chomp
      raise 'Aborted!' unless %w[y yes].include? input.downcase

      PostType.update(PostType::NEW_MEMBER_ID, group_id: nil)

      new_member_post_type_ids = new_member_post_types.map(&:id)
      Post.where(post_type_id: new_member_post_type_ids)
          .update_all(pttip_id: PostType::NEW_MEMBER_ID)
      new_member_post_types.delete_all
    end
  end
end
