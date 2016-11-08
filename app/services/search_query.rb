class SearchQuery
  def initialize(relation = User.all)
    @relation = relation
  end

  def search(term, page)
    page = 0 unless page
    count = Rails.configuration.x.results_per_page
    params = term.split.flat_map { |t| ["%#{t}%".downcase] * query_for_one_keyword.count('?') }
    query = ([query_for_one_keyword] * term.split.size).join(' AND ')
    return User.where(query, *params).offset(page.to_i * count).limit(count)
  end

  private

  def query_for_one_keyword
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
