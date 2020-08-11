class SvieController < ApplicationController
  def new
    redirect_to svie_edit_path unless current_user.primary_membership
  end

  def create
    current_user.update(update_params)

    begin
      date_of_birth = params[:date_of_birth].to_date
    rescue ArgumentError
      return redirect_to new_svie_path, alert: t(:bad_date_format)
    else
      current_user.update!(date_of_birth: date_of_birth)
    end

    current_user.svie.create_request(params[:svie_member_type])
    redirect_to svie_index_path, notice: t(:applied_succesful)
  end

  def edit
    @svie_memberships = current_user.memberships.select { |m| m.group.issvie }
    redirect_back fallback_location: root_url, alert: t(:svie_group_needed) if @svie_memberships.empty?
  end

  def update
    current_user.update(svie_primary_membership: params[:svie][:primary_membership])
    current_user.update(delegated: false)
    return redirect_to profiles_me_path, notice: t(:edit_successful) if current_user.svie.member?

    redirect_to new_svie_path
  end

  def index; end

  def hierarchy
    @parent_groups = Group.select { |group| group.parent.nil? }
  end

  def application_pdf
    pdf    = GenerateMembershipPdf.new(current_user)
    @user  = current_user
    @title = pdf.title
    @type  = pdf.type

    render layout: false
  end

  def destroy
    join_to(SvieUser::NOT_MEMBER)
  end

  def outside
    join_to(SvieUser::OUTSIDE_MEMBER)
  end

  def inside
    join_to(SvieUser::INSIDE_MEMBER)
  end

  private

  def join_to(member_type)
    return forbidden_page unless current_user.svie.can_join_to?(member_type)

    current_user.svie.create_request(member_type)
    redirect_to profiles_me_path, notice: t(:edit_successful)
  end

  def update_params
    params.permit(:home_address, :mother_name, :place_of_birth, :birth_name, :email)
  end
end
