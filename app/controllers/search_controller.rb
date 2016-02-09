class SearchController < ApplicationController
  def search 
    if params['query'].to_s != '' 
      param = "%#{params['query']}%"
      # @korok  User.find_by(usr_korok: param) TODO FIXME
      @users =  User.where("usr_lastname  LIKE ? OR usr_firstname  LIKE ? OR usr_nickname  LIKE ?", param, param, param)
      @others =  User.where("usr_dormitory  LIKE ? OR usr_room  LIKE ? OR usr_webpage  LIKE ? OR usr_email  LIKE ?",param ,param, param, param) ## azért majd csak azt adjuk vissza amit publicra állított. #FIXME TODO: Kör leírásában is kereshetünk
    end

##    raise ## hibát emelünk -> html felületen debug módba ugrunk
  end
end
