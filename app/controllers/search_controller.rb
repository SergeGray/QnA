class SearchController < ApplicationController
  authorize_resource class: false

  def result
    @result = SearchService.new(search_params).call
  end

  private

  def search_params
    params.permit(:query)
  end
end
