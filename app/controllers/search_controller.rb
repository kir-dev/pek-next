class SearchController < ApplicationController
  def search 
    x = 5
    if params['query'].to_s != '' 
      param = "%#{params['query']}%"
      # @korok  User.find_by(usr_korok: param) TODO FIXME
      @users_name =  User.where("usr_lastname  LIKE ? OR usr_firstname  LIKE ?", param, param)
      @UsersNameFirstX = @users_name[0..(x/2.0).round(0)-1]
      @users_nick =  User.where("usr_nickname  LIKE ?", param)
      @UsersNickFirstX = @users_nick[0..(x/2.0).round(0)-1]
      @others =  User.where("usr_dormitory  LIKE ? OR usr_room  LIKE ? OR usr_webpage  LIKE ? OR usr_email LIKE ? ",param ,param, param, param) ## azért majd csak azt adjuk vissza amit publicra állított. #FIXME TODO: Kör leírásában is kereshetünk
      @OthersFirstX = others = @others[0..x-1]
      @phonenumbers = User.where("usr_cell_phone LIKE ?",param)
      @PhoneNumbersFirstX = @phonenumbers[0..x-1]

## --------------- ----------------------------------------------- --------------------
## Ezek itt lent még nem működnek
'      groups = User.where("grp_name LIKE ? OR grp_description LIKE ?", param, param)
      
      @GroupsFirsX = groups.first(x)
      @GruplsAll = groups
'

## Eddig nem működik
## ---------------- ----------------------------------------------- --------------------
    end
##    raise ## hibát emelünk -> html felületen debug módba ugrunk
  end
end
