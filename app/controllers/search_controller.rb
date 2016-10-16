class SearchController < ApplicationController
  def search
    
  end

  def suggest
    if params['query'].to_s != ''
      param = "%#{params['query']}%".downcase
      results =  User.where("lower(usr_lastname || ' ' || usr_firstname) LIKE ? OR lower(usr_nickname) LIKE ?\
       OR lower(usr_email) LIKE ? OR usr_cell_phone LIKE ?", param, param, param, param).limit(10)

      render partial: 'suggest', locals: {results: results}
    end

  end
end
