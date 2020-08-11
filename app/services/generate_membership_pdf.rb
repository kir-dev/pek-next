class GenerateMembershipPdf
  TITLES = {
      inside_member:   'Tagfelvételi kérelem <br> rendes tagsághoz',
      outside_member:  'Tagfelvételi kérelem <br> külső tagsághoz',
      not_member:      'Kilépési nyilatkozat',
      inactive_member: 'Tagfelvételi kérelem <br> öreg tagsághoz'
  }.freeze

  def initialize(user)
    @user = user
  end

  def title
    TITLES[type].html_safe
  end

  def type
    case @user.svie_post_request.member_type
    when SvieUser::INSIDE_MEMBER
      :inside_member
    when SvieUser::OUTSIDE_MEMBER
      :outside_member
    when SvieUser::NOT_MEMBER
      :not_member
    when SvieUser::INACTIVE_MEMBER
      :inactive_member
    end
  end
end
