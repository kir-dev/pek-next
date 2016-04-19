class SearchController < ApplicationController
  def search
    
  end

  def suggest
    if params['query'].to_s != ''
      param = "%#{params['query']}%".downcase
      @results =  User.where("lower(usr_lastname || ' ' || usr_firstname) LIKE ? OR lower(usr_nickname) LIKE ?", param, param).limit(10)

      render partial: 'suggest_partial'
    end

  end
end
