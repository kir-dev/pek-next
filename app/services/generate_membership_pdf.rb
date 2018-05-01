require "render_anywhere"

class GenerateMembershipPdf
  include RenderAnywhere

  def initialize(user)
    @user = user
  end

  def as_html
    member_type = 'insider' if @user.svie_post_request.member_type == 'BELSOSTAG'
    member_type = 'outsider' if @user.svie_post_request.member_type == 'KULSOSTAG'
    member_type = 'not_member' if @user.svie_post_request.member_type == 'NEMTAG'

    render template: "svie/pdf/#{member_type}",
           layout: "membership_pdf", locals: { user: @user }
  end
end
