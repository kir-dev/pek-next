# frozen_string_literal: true

module EvaluationsControllerHelper
  private

  def set_search
    @search = OpenStruct.new(term: params[:term]&.downcase, start_with?: !!params[:start_with])
  end

  def search_users
    return if @search.term.blank?

    query = @search.start_with? ? "#{@search.term}%" : "%#{@search.term}%"
    @users = @users.where("full_name like ?", query)
  end
end
