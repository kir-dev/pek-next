class MembershipViewModelDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers
  decorates_association :group

  def edit_group_button
    return unless membership_view_model.leader?

    styled_link_to('Adatok szerkesztése', edit_group_path(membership_view_model.group))
  end

  def edit_group_delegates_button
    return unless membership_view_model.leader? && membership_view_model.group.issvie

    styled_link_to('Küldöttek', group_delegates_path(membership_view_model.group))
  end

  def join_group_button
    return unless membership_view_model.group.users_can_apply &&
                  (!current_user.membership_for(membership_view_model.group) ||
                  current_user.membership_for(membership_view_model.group).can_request_unarchivation?)

    form_tag group_memberships_path(membership_view_model.group), method: :post do
      button_tag('Jelentkezés körbe', class: 'uk-button uk-button-primary uk-width-1-1 uk-margin-top')
    end
  end

  def withdraw_membership_button
    group = membership_view_model.group
    membership = current_user.membership_for(group)

    return unless current_user.membership_for(group)&.has_post?(PostType::DEFAULT_POST_ID)

    form_tag withdraw_group_membership_path(group.id, membership), method: :post do
      button_tag('Jelentkezés visszavonása', class: 'uk-button uk-button-primary uk-width-1-1 uk-margin-top')
    end
end

  def leader_info_button
    return unless membership_view_model.leader?

    button_tag('Help me!', class: 'uk-button uk-button-primary uk-width-1-1 uk-margin-top',
                           'data-uk-modal': '{target:\'#info\'}')
  end

  def leader_info
    return unless membership_view_model.leader?

    render 'leader_info'
  end

  def evaluation_button
    return unless policy(current_evaluation).current?

    styled_link_to('Értékelés megtekintése',
                   group_evaluations_current_path(membership_view_model.group))
  end

  def all_members_count
    membership_view_model.group.memberships.count
  end

  def active_members_count
    acive_users_count(membership_view_model.group)
  end

  def inactive_members_count
    inacive_users_count(membership_view_model.group)
  end

  def archived_members_count
    archived_users_count(membership_view_model.group)
  end

  def edit_group_post_types_button
    return unless membership_view_model.leader?

    styled_link_to('Posztok szerkesztése', group_post_types_path(membership_view_model.group))
  end

  private

  def styled_link_to(name, path)
    link_to(name, path, class: 'uk-button uk-button-primary uk-width-1-1 uk-margin-top')
  end
end
