class SearchQuery
  def initialize(relation = User.all)
    @relation = relation
  end

  def user_search(term, offset, count)
    offset = 0 unless offset
    params = term.split.flat_map { |t| ["%#{t}%".mb_chars.downcase.to_s] * 
      user_query_for_one_keyword.count('?') }
    query = ([user_query_for_one_keyword] * term.split.size).join(' AND ')
    return User.where(query, *params).order(metascore: :desc).offset(offset).limit(count)
  end

  def group_search(term, offset)
    offset = 0 unless offset
    count = Rails.configuration.x.results_per_page
    query = 'lower(grp_name) LIKE ?'
    param = "%#{term}%".mb_chars.downcase.to_s
    return Group.where(query, param).order(grp_name: :desc).offset(offset.to_i).limit(count)
  end

  private

  def user_query_for_one_keyword
    <<-SQL.squish
      (lower(usr_lastname) LIKE ?
      OR lower(usr_firstname) LIKE ?
      OR lower(usr_nickname) LIKE ?
      OR lower(usr_email) LIKE ?
      OR (usr_cell_phone LIKE ? AND length(?) >= 8 )
      OR lower(usr_dormitory) LIKE ?
      OR usr_room LIKE ?)
    SQL
  end
end
