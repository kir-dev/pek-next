class DelegatesController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:show, :create, :destroy]
  before_action :require_svie_admin, only: [:index, :export]

  def index
    @delegates = User.where(delegated: true).order(:lastname).page(params[:page]).per(params[:per])
     .select{ |user| user.primary_membership.group.issvie }
  end

  def export
    @delegates = User.where(delegated: true).order(:lastname)

    require "prawn/table"
    require "prawn"

    Prawn::Document.generate("delegates.pdf") do |pdf|
      table_data = Array.new
      table_data << ["Név", "Kör", "Email", "Aláíras"]
      @delegates.each do |user|
        table_data << [user.full_name, user.primary_membership.group.name, user.email, ""]
      end
      pdf.font_families.update("Helvetica"=>{:normal => Rails.root.join('app', 'assets/fonts', 'HELR45W.ttf').to_s})
      pdf.font "Helvetica"
      pdf.table(table_data) do |table|
        table.column_widths=[110,100,130,200]
      end
    end
    File.open("#{Rails.root}/delegates.pdf", 'r') do |f|
      send_data f.read, type: "application/pdf"
    end
    File.delete("#{Rails.root}/delegates.pdf")

  end

  def show
    #There are 68 active svie members without a primary group
    @eligible_members = @group.members.where(svie_member_type: 'RENDESTAG').order(:lastname)
      .select { |user| !user.primary_membership.nil? && !user.primary_membership.newbie? &&
        user.primary_membership.group_id == params[:group_id].to_i && user.primary_membership.end.nil? }
  end

  def create
    unless @group.can_delegate_more
      redirect_to group_delegates_path(params[:group_id]), alert: t(:too_many_delegates)
      return
    end
    User.find(params[:member_id]).update(delegated: true)
    redirect_to group_delegates_path(params[:group_id])
  end

  def destroy
    User.find(params[:member_id]).update(delegated: false)
    redirect_to group_delegates_path(params[:group_id])
  end

end
