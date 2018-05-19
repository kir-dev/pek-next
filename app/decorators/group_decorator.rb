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

  def goup_leader_link
    return unless group.leader
    link_to(group.leader.user.full_name, profile_path(group.leader.user.screen_name))
  end

  def webpage_link
    return unless group.webpage
    link_to(group.webpage, group.webpage)
  end

  def svie_state
    group.issvie ? 'Igen' : 'Nem'
  end

  private
    def format_description
      group.description.gsub('[-----------------------------------------]','<br/>')
    end

end
