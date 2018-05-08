require "render_anywhere"

class GenerateMembershipPdf
  include RenderAnywhere

  def initialize(user)
    @user = user
  end

  def as_html
    member_type = 'insider' if @user.svie_post_request.member_type == SvieUser::INSIDE_MEMBER
    member_type = 'outsider' if @user.svie_post_request.member_type == SvieUser::OUTSIDE_MEMBER
    member_type = 'not_member' if @user.svie_post_request.member_type == SvieUser::NOT_MEMBER
    member_type = 'inactive' if @user.svie_post_request.member_type == SvieUser::INACTIVE_MEMBER

    render template: "svie/pdf/#{member_type}",
           layout: "membership_pdf", locals: { user: @user }
  end
end
