class GroupsController < ApplicationController
  before_action :require_login

  def show
    params[:group_id]

    @group = {
      name: "KIR fejlesztők és üzemeltetők",
      type: "szakmai kör",
      description: "A Villanykari Információs Rendszer fejlesztésével és üzemeltetésével foglalkozó kör.",
      webpage: "http://kir-dev.sch.bme.hu",
      maillist: "kir-dev@sch.bme.hu",
      head: "KIR admin",
      funded: 2011,
      issvie: true,
      users_can_apply: true      
    }
  end
end
