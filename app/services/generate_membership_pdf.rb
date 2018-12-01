require 'render_anywhere'

class GenerateMembershipPdf
  include RenderAnywhere

  def initialize(user)
    @user = user
  end

  def as_html
    user_member_type = @user.svie_post_request.member_type
    member_type = 'inside_member' if user_member_type == SvieUser::INSIDE_MEMBER
    member_type = 'outside_member' if user_member_type == SvieUser::OUTSIDE_MEMBER
    member_type = 'not_member' if user_member_type == SvieUser::NOT_MEMBER
    member_type = 'inactive_member' if user_member_type == SvieUser::INACTIVE_MEMBER

    render template: "svie/pdf/#{member_type}", layout: 'membership_pdf', locals: { user: @user }
  end
end
