class SearchQuery
  def initialize(relation = User.all)
    @relation = relation
  end

  def search(term)
    terms = term.split
    params = []
    terms.each do |t|
      params += ["%#{t}%".downcase] * query_for_one_keyword.count('?')
    end
    query = ([query_for_one_keyword] * terms.size).join(' AND ')
    return User.where(query, *params).limit(10)
  end

  private

  def query_for_one_keyword()
    return "(lower(usr_lastname) LIKE ? \
     OR lower(usr_firstname) LIKE ? \
     OR lower(usr_nickname) LIKE ? \
     OR lower(usr_email) LIKE ? \
     OR usr_cell_phone LIKE ? \
     OR lower(usr_dormitory) LIKE ?
     OR usr_room LIKE ?)"
  end

end
