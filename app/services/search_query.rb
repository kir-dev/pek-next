class SearchQuery
  def initialize(relation = User.all)
    @relation = relation
  end

  def user_search(term, offset, count)
    offset ||= 0
    params = term.split.flat_map do |t|
      ["%#{t}%".mb_chars.downcase.to_s] * user_query_for_one_keyword.count('?')
    end
    query = ([user_query_for_one_keyword] * term.split.size).join(' AND ')
    User.where(query, *params).order('metascore DESC NULLS LAST').offset(offset).limit(count)
  end

  def group_search(term, offset)
    offset ||= 0
    count = Rails.configuration.x.results_per_page
    query = 'lower(name) LIKE ?'
    param = "%#{term}%".mb_chars.downcase.to_s
    Group.where(query, param).order(name: :desc).offset(offset.to_i).limit(count)
  end

  private

  def user_query_for_one_keyword
    <<-SQL.squish
      (lower(lastname) LIKE ?
      OR lower(firstname) LIKE ?
      OR lower(nickname) LIKE ?
      OR lower(email) LIKE ?
      OR (cell_phone LIKE ? AND length(?) >= 8 )
      OR lower(dormitory) LIKE ?
      OR room LIKE ?)
    SQL
  end
end
