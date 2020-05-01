class SearchController < ApplicationController
  before_action :require_pek_admin, only: :suggest_leader

  def search; end

  def suggest
    user_results = []

    if params.key?(:query)
      group_results = SearchQuery.new.group_search(params[:query], params[:group_count])
      group_results = group_results.decorate
      count = Rails.configuration.x.results_per_page - group_results.count
      user_results = SearchQuery.new.user_search(params[:query], params[:user_count], count)
      user_results = user_results.decorate
    end

    render partial: 'suggest', locals: { users: user_results || [], groups: group_results || [] }
  end

  def suggest_leader
    return unless params.key?(:query)

    result_per_page = Rails.configuration.x.results_per_page
    offset = result_per_page * params[:page].to_i
    user_results = SearchQuery.new.user_search(params[:query], offset, result_per_page).decorate

    render partial: 'suggest_leader', locals: { users: user_results || [] }
  end
end
