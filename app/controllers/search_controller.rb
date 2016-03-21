class SearchController < ApplicationController
  def search 
    x = 5
    if params['query'].to_s != '' 
      param = "%#{params['query']}%"
      # @korok  User.find_by(usr_korok: param) TODO FIXME
      @users_name =  User.where("usr_lastname  LIKE ? OR usr_firstname  LIKE ?", param, param).limit(50)
      @UsersNameFirstX = @users_name[0..(x/2.0).round(0)-1]
      @users_nick =  User.where("usr_nickname  LIKE ?", param).limit(50)
      @UsersNickFirstX = @users_nick[0..(x/2.0).round(0)-1]
      @others =  User.where("usr_dormitory  LIKE ? OR usr_room  LIKE ? OR usr_webpage  LIKE ? OR usr_email LIKE ? ",param ,param, param, param).limit(50) ## azért majd csak azt adjuk vissza amit publicra állított. #FIXME TODO: Kör leírásában is kereshetünk
      @OthersFirstX = others = @others[0..x-1]
      @phonenumbers = User.where("usr_cell_phone LIKE ?",param).limit(50)
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
  end

  def suggest
    if params['query'].to_s != ''
      param = "%#{params['query']}%"
      @by_nick =  User.where("usr_nickname LIKE ?", param).limit(3)
      @by_name =  User.where("(usr_lastname || ' ' || usr_firstname) LIKE ?", param).limit(3)

      render partial: 'suggest_partial'
    end

  end
end
