class PointHistoryDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def explanation
    return if point_history.entry_card_explanation.blank?
    return content_tag(:div,
      point_history.entry_card_explanation,
      class: 'uk-width-1-1 uk-text-justify uk-margin-top')
  end

  def group_link
    link_to point_history.group_name, group_path(point_history.group_id)
  end
end
