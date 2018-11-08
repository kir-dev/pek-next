class SearchController < ApplicationController
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
end
