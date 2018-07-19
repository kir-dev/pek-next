class MembershipViewModelDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers
  decorates_association :group

  def edit_group_button
    return unless membership_view_model.leader?
    link_to('Adatok szerkesztése', edit_group_path(membership_view_model.group),
      class: 'uk-button uk-button-primary uk-width-1-1')
  end

  def edit_group_delegates_button
    return unless membership_view_model.leader? && membership_view_model.group.issvie
    link_to('Küldöttek', group_delegates_path(membership_view_model.group),
      class: 'uk-button uk-button-primary uk-width-1-1')
  end

  def join_group_button
    return unless membership_view_model.group.users_can_apply && !current_user.membership_for(membership_view_model.group)
    form_tag group_memberships_path(membership_view_model.group), {method: 'post'} do
      button_tag('Jelentkezés körbe', {class: 'uk-button uk-button-primary uk-width-1-1'})
    end
  end

  def new_evaluation_button
    return unless membership_view_model.leader? && SystemAttribute.application_season?
    link_to('Értékelés leadás', group_evaluations_current_path(membership_view_model.group),
      class: 'uk-button uk-button-primary uk-width-1-1')
  end

  def leader_info_button
    return unless membership_view_model.leader?
    button_tag('Help me!', {
      class: 'uk-button uk-button-primary uk-width-1-1',
      'data-uk-modal': '{target:\'#info\'}'
    })
  end

  def leader_info
    return unless membership_view_model.leader?
    render 'leader_info'
  end

  def resort_leader_evaluation_button
    return  unless membership_view_model.resort_leader?
    link_to('Értékelés megtekintése', group_evaluations_current_path(membership_view_model.group),
            class: 'uk-button uk-button-primary uk-width-1-1')
  end

end
