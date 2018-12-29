class GroupDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def formatted_description
    return unless group.description

    simple_format(format_description)
  end

  def truncated_description
    return unless group.description

    description = truncate(format_description, length: 100)
    simple_format(description, { class: 'uk-panel-body uk-padding-small' },
                  wrapper_tag: 'div')
  end

  def group_leader_link
    return unless group.leader

    group.leader.user.decorate.link
  end

  def webpage_link
    return unless group.webpage

    link_to(group.webpage, group.webpage)
  end

  def svie_state
    group.issvie ? 'Igen' : 'Nem'
  end

  def parent
    return '-' unless group.parent

    link_to group.parent.name, group.parent
  end

  def link(options = {})
    link_to group.name, group_path(group.id), options
  end

  private

  def format_description
    group.description.gsub('[-----------------------------------------]', '<br/>')
  end
end
