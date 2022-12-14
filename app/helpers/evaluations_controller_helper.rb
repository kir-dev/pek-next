# frozen_string_literal: true

module EvaluationsControllerHelper
  private

  def set_search
    @search = OpenStruct.new(term:       search_params[:term]&.downcase,
                             start_with: !!search_params[:start_with],
                             sub_groups: search_params[:sub_groups] || [])
  end

  def search_params
    params.fetch(:search, {}).permit(:term, :start_with, sub_groups: [])
  end

  def search_users
    return if @search.term.blank?

    query  = @search.start_with? ? "#{@search.term}%" : "%#{@search.term}%"
    @users = @users.where("full_name like ?", query)
  end

  def filter_users
    return if @search.sub_groups.empty? || @sub_groups.empty?

    @users = @users.joins(:sub_groups).where(sub_groups: { id: @search.sub_groups })

  end

  def filter_principles
    return if @search.sub_groups.empty? || @sub_groups.empty?

    @ordered_principles = @ordered_principles.where(sub_group_id: @search.sub_groups)
  end
end
