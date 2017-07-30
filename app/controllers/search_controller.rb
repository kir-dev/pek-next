class SearchController < ApplicationController
  before_action :require_login

  def search
  end

  def suggest
    user_results = []

    if params.key?(:query)
      group_results = SearchQuery.new.group_search(params[:query], params[:page])
      count = Rails.configuration.x.results_per_page - group_results.count
      user_results = SearchQuery.new.user_search(params[:query], params[:page], count)
    end

    render partial: 'suggest', locals: {users: user_results ||= [], groups: group_results ||= []}
  end
end
