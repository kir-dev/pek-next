class GroupMemberDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def svie_status_icon
    return unless membership.active?
    return icon_tag('uk-icon-remove', 'Nem SVIE tag') if !user.svie.member? ||
                                                         user.svie.in_processing?
    return icon_tag('uk-icon-heart', 'Pártolótag') if user.svie.outside_member?
    return icon_tag('uk-icon-check-square', 'Más elsődleges kör') unless primary_member?

    icon_tag('uk-icon-check', 'Rendes tag')
  end

  def membership_time
    return "#{l start_date} - #{l end_date}" if membership.inactive?

    "#{l start_date} -"
  end

  def edit_post_button(group)
    return if membership.inactive?

    form_tag(group_membership_posts_path(group.id, membership_id),
             method: :get, class: 'uk-form') do
      button_tag '', name: nil, class: 'uk-icon-edit uk-button uk-button-small',
                     'data-uk-tooltip': '', title: 'Posztok szerkesztése'
    end
  end

  def approve_join_button(group)
    return unless membership.newbie?

    button_to 'Elfogadás',
              group_membership_accept_path(group.id, membership_id),
              method: :post, remote: true,
              class: 'uk-button uk-button-success uk-button-small uk-width-auto',
              id: "approve-button-#{membership_id}"
  end

  def reject_join_button(group)
    return unless membership.newbie?

    button_to 'Elutasítás',
              withdraw_group_membership_path(group, membership_id),
              method: :post, remote: true,
              class: 'uk-button uk-button-danger uk-button-small uk-width-auto',
              id: "reject-button-#{membership_id}"
  end

  def inactivate_user_button(group)
    return unless membership.active?

    button_to 'Öreggé avatás',
              group_membership_inactivate_path(group.id, membership_id),
              method: :post, remote: true,
              class: 'uk-button uk-button-primary uk-button-small uk-width-auto',
              id: "inactive-button-#{membership_id}"
  end

  def archive_user_button(group)
    return if membership.archived? || membership.newbie?

    button_to 'Archiválás',
              group_membership_archive_path(group.id, membership_id),
              method: :put, remote: true,
              class: 'uk-button uk-button-small uk-button-primary uk-width-auto',
              style: 'background-color: #ed8d34',
              id: "archive-button-#{membership_id}",
              data: { confirm: "Biztos, hogy archiválni szeretnéd #{user.full_name}-t?" }
  end

  def reactivate_user_button(group)
    return unless membership.inactive?

    button_to 'Újraaktiválás',
              group_membership_reactivate_path(group.id, membership_id),
              method: :post, remote: true,
              class: 'uk-button uk-button-primary uk-button-small uk-width-auto',
              id: "reactivate-button-#{membership_id}"
  end

  def unarchive_user_button(group)
    return unless membership.archived?

    button_to 'Archiválás visszavonása',
              group_membership_unarchive_path(group.id, membership_id),
              method: :put, remote: true,
              class: 'uk-button uk-button-danger uk-button-small uk-width-auto',
              id: "unarchive-button-#{membership_id}"
  end

  def group_link(options = {})
    membership.group.decorate.link options
  end

  def user_link(options = {})
    membership.user.decorate.link_with_compact_name options
  end
end
