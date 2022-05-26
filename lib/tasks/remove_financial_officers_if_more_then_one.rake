namespace :pek do
  desc "This task removes the financial officers from each group where there is more than one"
  task remove_financial_officers: :environment do
    puts 'Starting to remove unused financial officers...'
    groups_with_fo_count = Group.joins(memberships: :posts)
                                .where('posts.post_type_id': PostType::FINANCIAL_OFFICER_POST_ID)
                                .group('memberships.group_id').count('groups.id')
    group_ids_with_more_fo = groups_with_fo_count.select { |k, v| v > 1 }.keys
    groups_with_more_fo = Group.where(id: group_ids_with_more_fo)
    groups_with_more_fo.each do |group|
      fo_posts = Post.where('memberships.group_id': group.id,
                            post_type_id: PostType::FINANCIAL_OFFICER_POST_ID)
                     .joins(:membership).order('posts.id': :asc)
      fo_posts[0..-2].each { |post| post.destroy! }
    end
    puts 'Finished removing unused financial officers!'
  end
end