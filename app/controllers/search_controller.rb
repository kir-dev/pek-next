class SearchController < ApplicationController
  before_action :require_login

  def search
  end

  def suggest
    results = []

    if params.key?(:query)
      results = SearchQuery.new.search(params[:query], params[:page])
    end

    render partial: 'suggest', locals: {results: results}

  end
end
