class SearchController < ApplicationController
  authorize_resource class: false

  def index
    @result = SearchService.call(search_params.to_h.symbolize_keys)
  end

  private

  def search_params
    params.permit(:query, :resource)
  end
end
