class SearchController < ApplicationController
  def search
  end

  def suggest
    results = []

    if params.key?(:query)
      results = SearchQuery.new.search(params[:query])
    end

    render partial: 'suggest', locals: {results: results}

  end
end
